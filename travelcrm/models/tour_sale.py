# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    ForeignKey,
    Table,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


tour_sale_person = Table(
    'tour_sale_person',
    Base.metadata,
    Column(
        'tour_sale_id',
        Integer,
        ForeignKey(
            'tour_sale.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_tour_sale_id_tour_sale_person',
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
            name='fk_person_id_tour_sale_person',
        ),
        primary_key=True,
    ),
)


tour_sale_invoice = Table(
    'tour_sale_invoice',
    Base.metadata,
    Column(
        'tour_sale_id',
        Integer,
        ForeignKey(
            'tour_sale.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_tour_sale_id_tour_sale_invoice',
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
            name='fk_invoice_id_tour_sale_invoice',
        ),
        primary_key=True,
    ),
)


class TourSale(Base):
    __tablename__ = 'tour_sale'

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
            name="fk_resource_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    touroperator_id = Column(
        Integer,
        ForeignKey(
            'touroperator.id',
            name="fk_touroperator_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    advsource_id = Column(
        Integer,
        ForeignKey(
            'advsource.id',
            name="fk_advsource_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    base_price = Column(
        Numeric(16, 2),
        nullable=False
    )
    adults = Column(
        Integer,
        nullable=False,
    )
    children = Column(
        Integer,
        nullable=False,
    )
    start_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_start_location_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    end_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_end_location_id_tour_sale",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    start_date = Column(
        Date,
        nullable=False,
    )
    end_date = Column(
        Date,
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'tour_sale',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    customer = relationship(
        'Person',
        backref=backref(
            'customers_tours_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'tours_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    touroperator = relationship(
        'Touroperator',
        backref=backref(
            'tours_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'tours_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    advsource = relationship(
        'Advsource',
        backref=backref(
            'tours_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    start_location = relationship(
        'Location',
        backref=backref(
            'tours_sales_starts',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[start_location_id],
        uselist=False,
    )
    end_location = relationship(
        'Location',
        backref=backref(
            'tours_sales_ends',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[end_location_id],
        uselist=False,
    )
    persons = relationship(
        'Person',
        secondary=tour_sale_person,
        backref=backref(
            'tours_sales',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=True,
    )
    invoice = relationship(
        'Invoice',
        secondary=tour_sale_invoice,
        backref=backref(
            'tour_sale',
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
        return self.base_price
