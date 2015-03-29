# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Order(Base):
    __tablename__ = 'order'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    deal_date = Column(
        Date,
        nullable=False,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    advsource_id = Column(
        Integer,
        ForeignKey(
            'advsource.id',
            name="fk_advsource_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    invoice_id = Column(
        Integer,
        ForeignKey(
            'invoice.id',
            name="fk_invoice_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    calculation_id = Column(
        Integer,
        ForeignKey(
            'calculation.id',
            name="fk_calculation_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'order',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    customer = relationship(
        'Person',
        backref=backref(
            'orders',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    advsource = relationship(
        'Advsource',
        backref=backref(
            'orders',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    invoice = relationship(
        'Invoice',
        backref=backref(
            'order',
            uselist=False,
        ),
        uselist=False,
    )
    calculation = relationship(
        'Calculation',
        backref=backref(
            'order',
            uselist=False,
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

    @property
    def base_sum(self):
        return sum(
            service_item.base_price for service_item in self.services_items
        )
