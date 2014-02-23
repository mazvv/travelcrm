# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
    event,
)
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
)
from ..search.currency import (
    schema,
    get_currency_index
)


class Currency(Base):
    __tablename__ = 'currency'
    __table_args__ = (
        UniqueConstraint(
            'iso_code',
            name='unique_idx_currency_iso_code',
            use_alter=True,
        ),
    )

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_currency",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    iso_code = Column(
        String(length=3),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref('currency', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)


def add_to_search_index_event(mapper, connection, target):
    ix = get_currency_index()
    writer = ix.writer()
    writer.add_document(
        id=unicode(target.id),
        iso_code=target.iso_code,
        owner_structure=target.resource.owner_structure.name,
        status=unicode(target.resource.status),
    )


def delete_from_search_index_event(mapper, connection, target):
    ix = get_currency_index()
    target.logging()


event.listen(Currency, 'after_insert', add_to_search_index_event)
event.listen(Currency, 'after_update', add_to_search_index_event)
event.listen(Currency, 'after_delete', delete_from_search_index_event)
