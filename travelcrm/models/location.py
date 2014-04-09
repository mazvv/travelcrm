# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    )
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


class Location(Base):
    __tablename__ = 'location'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_location",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    region_id = Column(
        Integer(),
        ForeignKey(
            'region.id',
            name='fk_region_id_location',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False
    )

    resource = relationship(
        'Resource',
        backref=backref('location', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )
    region = relationship(
        'Region',
        backref=backref(
            'locations',
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
