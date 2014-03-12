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


class Licence(Base):
    __tablename__ = 'licence'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_hotelcat",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    licence_num = Column(
        String,
        nullable=False,
    )
    date_from = Column(
        Date,
        nullable=False
    )
    date_to = Column(
        Date,
        nullable=False
    )
    resource = relationship(
        'Resource',
        backref=backref('licence', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
