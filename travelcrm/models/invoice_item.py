# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


class InvoiceItem(Base):
    __tablename__ = 'invoice_item'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    invoice_id = Column(
        Integer,
        ForeignKey(
            'invoice.id',
            name="fk_invoice_id_invoice_item",
            ondelete='cascade',
            onupdate='cascade',
        ),
        nullable=False,
    )
    order_item_id = Column(
        Integer,
        ForeignKey(
            'order_item.id',
            name="fk_order_item_id_invoice_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    vat = Column(
        Numeric(16, 2),
        default=0,
        nullable=False
    )
    discount = Column(
        Numeric(16, 2),
        default=0,
        nullable=False
    )
    descr = Column(
        String(255),
    )
    order_item = relationship(
        'OrderItem',
        backref=backref(
            'invoice_item',
            uselist=False,
        ),
        uselist=False,
    )
    invoice = relationship(
        'Invoice',
        backref=backref(
            'invoices_items',
            lazy='dynamic',
            uselist=True,
            cascade='all, delete-orphan'
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

    @hybrid_property
    def final_price(self):
        return self.price - self.discount
