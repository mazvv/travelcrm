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
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    hotelcat_id = Column(
        Integer,
        ForeignKey(
            'hotelcat.id',
            name="fk_hotelcat_id_hotel",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_location_id_hotel",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    name = Column(
        String(length=32),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'hotel',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    hotelcat = relationship(
        'Hotelcat',
        backref=backref(
            'hotels',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False
    )
    location = relationship(
        'Location',
        backref=backref(
            'hotels',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False
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
    def full_hotel_name(self):
        return (
            self.name
            + ' (' + self.hotelcat.name + ')'
        )
