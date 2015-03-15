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


class Address(Base):
    __tablename__ = 'address'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_address",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_location_id_address",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    zip_code = Column(
        String(length=12),
        nullable=False,
    )
    address = Column(
        String(length=255),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'address',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    location = relationship(
        'Location',
        backref=backref(
            'addresses',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )

    @hybrid_property
    def name(self):
        return self.last_name + " " + self.first_name

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
