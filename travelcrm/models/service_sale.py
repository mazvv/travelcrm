# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    ForeignKey,
    Table,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


service_sale_service_item = Table(
    'service_sale_service_item',
    Base.metadata,
    Column(
        'service_sale_id',
        Integer,
        ForeignKey(
            'service_sale.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_service_sale_id_service_sale_service_item',
        ),
        primary_key=True,
    ),
    Column(
        'service_item_id',
        Integer,
        ForeignKey(
            'service_item.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_service_item_id_service_sale_service_item',
        ),
        primary_key=True,
    ),
)

service_sale_invoice = Table(
    'service_sale_invoice',
    Base.metadata,
    Column(
        'service_sale_id',
        Integer,
        ForeignKey(
            'service_sale.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_service_sale_id_service_sale_invoice',
        ),
        primary_key=True,
    ),
    Column(
        'invoice_id',
        Integer,
        ForeignKey(
            'invoice.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_invoice_id_service_sale_invoice',
        ),
        primary_key=True,
    ),
)


class ServiceSale(Base):
    __tablename__ = 'service_sale'

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
            name="fk_resource_id_service_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_service_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    advsource_id = Column(
        Integer,
        ForeignKey(
            'advsource.id',
            name="fk_advsource_id_service_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'service_sale',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    customer = relationship(
        'Person',
        backref=backref(
            'services_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    advsource = relationship(
        'Advsource',
        backref=backref(
            'services_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    services_items = relationship(
        'ServiceItem',
        secondary=service_sale_service_item,
        backref=backref(
            'service_sale',
            uselist=False,
        ),
        uselist=True,
    )
    invoice = relationship(
        'Invoice',
        secondary=service_sale_invoice,
        backref=backref(
            'service_sale',
            uselist=False,
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @property
    def base_sum(self):
        return sum(
            service_item.base_price for service_item in self.services_items
        )
