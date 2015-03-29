# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


person_order_item = Table(
    'person_order_item',
    Base.metadata,
    Column(
        'order_item_id',
        Integer,
        ForeignKey(
            'order_item.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_order_item_id_person_order_item',
        ),
        primary_key=True,
    ),
    Column(
        'person_id',
        Integer,
        ForeignKey(
            'person.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_person_id_person_order_item',
        ),
        primary_key=True,
    ),
)


class OrderItem(Base):
    __tablename__ = 'order_item'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_order_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    order_id = Column(
        Integer,
        ForeignKey(
            'order.id',
            name="fk_order_id_order_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_order_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_order_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    touroperator_id = Column(
        Integer,
        ForeignKey(
            'touroperator.id',
            name="fk_touroperator_id_order_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    base_price = Column(
        Numeric(16, 2),
        default=0,
        nullable=False
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'order_item',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    order = relationship(
        'Order',
        backref=backref(
            'orders_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'orders_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'orders_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    touroperator = relationship(
        'Touroperator',
        backref=backref(
            'orders_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    persons = relationship(
        'Person',
        secondary=person_order_item,
        backref=backref(
            'orders_items',
            lazy='dynamic',
            uselist=True,
        ),
        lazy='dynamic',
        uselist=True,
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
