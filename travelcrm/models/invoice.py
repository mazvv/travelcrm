# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Invoice(Base):
    __tablename__ = 'invoice'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    date = Column(
        Date,
        nullable=False,
    )
    active_until = Column(
        Date,
        nullable=False,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_invoice",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    order_id = Column(
        Integer,
        ForeignKey(
            'order.id',
            name="fk_order_id_invoice",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_id_invoice",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'invoice',
            uselist=False,
            cascade="all,delete"
        ),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    order = relationship(
        'Order',
        backref=backref(
            'invoice',
            uselist=False,
        ),
        uselist=False,
    )
    account = relationship(
        'Account',
        backref=backref(
            'invoices',
            uselist=True,
            lazy="dynamic"
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
    def final_price(self):
        return sum([item.final_price for item in self.invoices_items])

    @property
    def discount(self):
        return sum([item.discount for item in self.invoices_items])

    @property
    def vat(self):
        return sum([item.vat for item in self.invoices_items])
