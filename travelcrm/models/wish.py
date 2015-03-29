# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    ForeignKey,
    String,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Wish(Base):
    __tablename__ = 'wish'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_wish",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_wish",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_wish",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    price_from = Column(
        Numeric(16, 2),
    )
    price_to = Column(
        Numeric(16, 2),
    )
    descr = Column(
        String(1024),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'wish',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'wishes',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'wishes',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
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
