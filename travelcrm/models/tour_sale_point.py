# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class TourSalePoint(Base):
    __tablename__ = 'tour_sale_point'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    tour_sale_id = Column(
        Integer,
        ForeignKey(
            'tour_sale.id',
            name="fk_tour_sale_id_tour_sale_point",
            ondelete='cascade',
            onupdate='cascade',
        ),
    )
    location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_location_id_tour_sale_point",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    hotel_id = Column(
        Integer,
        ForeignKey(
            'hotel.id',
            name="fk_hotel_id_tour_sale_point",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    accomodation_id = Column(
        Integer,
        ForeignKey(
            'accomodation.id',
            name="fk_accomodation_id_tour_sale_point",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    foodcat_id = Column(
        Integer,
        ForeignKey(
            'foodcat.id',
            name="fk_foodcat_id_tour_sale_point",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    roomcat_id = Column(
        Integer,
        ForeignKey(
            'roomcat.id',
            name="fk_roomcat_id_tour_sale_point",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    description = Column(
        String(length=255),
    )
    start_date = Column(
        Date,
        nullable=False,
    )
    end_date = Column(
        Date,
        nullable=False,
    )
    tour_sale = relationship(
        'TourSale',
        backref=backref(
            'points',
            uselist=True,
            lazy="dynamic",
            order_by='TourSalePoint.start_date',
        ),
        uselist=False,
    )
    hotel = relationship(
        'Hotel',
        backref=backref(
            'tours_sales_points',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    accomodation = relationship(
        'Accomodation',
        backref=backref(
            'tours_sales_points',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    roomcat = relationship(
        'Roomcat',
        backref=backref(
            'tours_sales_points',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    foodcat = relationship(
        'Foodcat',
        backref=backref(
            'tours_sales_points',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    location = relationship(
        'Location',
        backref=backref(
            'tours_sales_points',
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
