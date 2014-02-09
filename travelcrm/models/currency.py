# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
    )
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
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
        backref=backref('currency', uselist=False),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
