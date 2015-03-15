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
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    iso_code = Column(
        String(length=3),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'currency',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @classmethod
    def by_iso_code(cls, iso_code):
        return DBSession.query(cls).filter(cls.iso_code == iso_code).first()
