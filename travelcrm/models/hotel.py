# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    )
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Hotel(Base):
    __tablename__ = 'hotel'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_hotel",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    hotelcat_id = Column(
        Integer,
        ForeignKey(
            'hotelcat.id',
            name="fk_hotelcat_id_hotel",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_location_id_hotel",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    name = Column(
        String(length=32),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref('hotel', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )
    hotelcat = relationship(
        'Hotelcat',
        backref=backref(
            'hotels',
            uselist=True,
            cascade='all,delete',
            lazy="dynamic"
        ),
        uselist=False
    )
    location = relationship(
        'Location',
        backref=backref(
            'hotels',
            uselist=True,
            cascade='all,delete',
            lazy="dynamic"
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
