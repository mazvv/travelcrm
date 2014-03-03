# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    ForeignKey,
)
from sqlalchemy.dialects.postgresql import ENUM
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class TContact(Base):
    __tablename__ = '_tcontact'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    temporal_id = Column(
        Integer,
        ForeignKey(
            '_temporal.id',
            name="fk_tcontact_id_temporal_id",
            ondelete='cascade',
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
    deleted = Column(
        Boolean,
        default=False,
    )
    main_id = Column(
        Integer,
        ForeignKey(
            'contact.id',
            name="fk_main_id_contact_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    temporal = relationship(
        'Temporal',
        backref=backref(
            'contacts',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic",
        ),
        uselist=False,
    )
    main = relationship(
        'Contact',
        backref=backref(
            'temporals',
            uselist=True,
            cascade="all,delete"
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
