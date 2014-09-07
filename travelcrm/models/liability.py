# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    Date,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Liability(Base):
    __tablename__ = 'liability'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    date = Column(
        Date,
        nullable=False,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_liability",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'liability',
            uselist=False,
            cascade="all,delete"
        ),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
