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
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_contact",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
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
    resource = relationship(
        'Resource',
        backref=backref(
            'contact',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
