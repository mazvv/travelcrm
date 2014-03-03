# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.dialects.postgresql import ENUM
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Contact(Base):
    __tablename__ = 'contact'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    contact_type = Column(
        ENUM(
            u'phone', u'email', u'skype',
            name='contact_type_enum', create_type=True,
        ),
        nullable=False,
    )
    contact = Column(
        String,
        nullable=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
