# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


tour_order_item = Table(
    'tour_order_item',
    Base.metadata,
    Column(
        'order_item_id',
        Integer,
        ForeignKey(
            'order_item.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_order_item_id_tour_order_item',
        ),
        primary_key=True,
    ),
    Column(
        'tour_id',
        Integer,
        ForeignKey(
            'tour.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_tour_id_tour_order_item',
        ),
        primary_key=True,
    ),
)


class Tour(Base):
    __tablename__ = 'tour'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    start_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_start_location_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    start_transport_id = Column(
        Integer,
        ForeignKey(
            'transport.id',
            name="fk_start_transport_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    end_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_end_location_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    end_transport_id = Column(
        Integer,
        ForeignKey(
            'transport.id',
            name="fk_end_transport_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    hotel_id = Column(
        Integer,
        ForeignKey(
            'hotel.id',
            name="fk_hotel_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    accomodation_id = Column(
        Integer,
        ForeignKey(
            'accomodation.id',
            name="fk_accomodation_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    foodcat_id = Column(
        Integer,
        ForeignKey(
            'foodcat.id',
            name="fk_foodcat_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    roomcat_id = Column(
        Integer,
        ForeignKey(
            'roomcat.id',
            name="fk_roomcat_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    transfer_id = Column(
        Integer,
        ForeignKey(
            'transfer.id',
            name="fk_transfer_id_tour",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    adults = Column(
        Integer,
        nullable=False,
    )
    children = Column(
        Integer,
        nullable=False,
    )
    start_date = Column(
        Date,
        nullable=False,
    )
    start_additional_info = Column(
        String(length=128),
    )
    end_date = Column(
        Date,
        nullable=False,
    )
    end_additional_info = Column(
        String(length=128),
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'tour',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
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
    start_location = relationship(
        'Location',
        backref=backref(
            'tours_starts',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[start_location_id],
        uselist=False,
    )
    end_location = relationship(
        'Location',
        backref=backref(
            'tours_ends',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[end_location_id],
        uselist=False,
    )
    start_transport = relationship(
        'Transport',
        backref=backref(
            'tours_starts',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[start_transport_id],
        uselist=False,
    )
    end_transport = relationship(
        'Transport',
        backref=backref(
            'tours_ends',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[end_transport_id],
        uselist=False,
    )
    transfer = relationship(
        'Transfer',
        backref=backref(
            'tours',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    order_item = relationship(
        'OrderItem',
        secondary=tour_order_item,
        backref=backref(
            'tour',
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
