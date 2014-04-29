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


class Roomcat(Base):
    __tablename__ = 'roomcat'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_roomcat",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref('roomcat', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
