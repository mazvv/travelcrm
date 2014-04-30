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


class TourPoint(Base):
    __tablename__ = 'tour_point'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    tour_id = Column(
        Integer,
        ForeignKey(
            'tour.id',
            name="fk_tour_id_tour_point",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_location_id_tour_point",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    hotel_id = Column(
        Integer,
        ForeignKey(
            'hotel.id',
            name="fk_hotel_id_tour_point",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    accomodation_id = Column(
        Integer,
        ForeignKey(
            'accomodation.id',
            name="fk_accomodation_id_tour_point",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    foodcat_id = Column(
        Integer,
        ForeignKey(
            'foodcat.id',
            name="fk_foodcat_id_tour_point",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    roomcat_id = Column(
        Integer,
        ForeignKey(
            'roomcat.id',
            name="fk_roomcat_id_tour_point",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
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
    tour = relationship(
        'Tour',
        backref=backref(
            'points',
            uselist=True,
            lazy="dynamic",
            order_by='TourPoint.start_date',
        ),
        uselist=False,
    )
    hotel = relationship(
        'Hotel',
        backref=backref(
            'tours',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    accomodation = relationship(
        'Accomodation',
        backref=backref(
            'tours',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    roomcat = relationship(
        'Roomcat',
        backref=backref(
            'tours',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    foodcat = relationship(
        'Foodcat',
        backref=backref(
            'tours',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    location = relationship(
        'Location',
        backref=backref(
            'tours',
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
