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
    order_item_id = Column(
        Integer,
        ForeignKey(
            'order_item.id',
            name="fk_order_item_id_caluclation",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=True,
    )
    contract_id = Column(
        Integer,
        ForeignKey(
            'contract.id',
            name="fk_contract_id_caluclation",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=True,
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
    order_item = relationship(
        'OrderItem',
        backref=backref(
            'calculation',
            uselist=False,
        ),
        uselist=False,
    )
    contract = relationship(
        'Contract',
        backref=backref(
            'calculations',
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
