# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Location(Base):
    __tablename__ = 'location'
    __table_args__ = (
        UniqueConstraint(
            'name',
            'region_id',
            name='unique_idx_name_region_id_location',
        ),
    )

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
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    region_id = Column(
        Integer(),
        ForeignKey(
            'region.id',
            name='fk_region_id_location',
            onupdate='cascade',
            ondelete='restrict',
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'location',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    region = relationship(
        'Region',
        backref=backref(
            'locations',
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
    def full_location_name(self):
        return (
            self.name + ' - '
            + self.region.name
            + ' (' + self.region.country.name + ')'
        )
