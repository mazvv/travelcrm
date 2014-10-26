# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Calculation(Base):
    __tablename__ = 'calculation'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_calculation",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_item_id = Column(
        Integer,
        ForeignKey(
            'service_item.id',
            name="fk_service_item_id_caluclation",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_service_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'calculation',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'calclations',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    base_price = Column(
        Numeric(16, 2),
        nullable=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
