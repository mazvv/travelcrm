# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    Table,
    ForeignKey,
)
from sqlalchemy.dialects.postgresql import ENUM
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


person_contact = Table(
    'person_contact',
    Base.metadata,
    Column(
        'person_id',
        Integer,
        ForeignKey(
            'person.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_person_id_person_contact',
        ),
        primary_key=True,
    ),
    Column(
        'contact_id',
        Integer,
        ForeignKey(
            'contact.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_contact_id_person_contact',
        ),
        primary_key=True,
    )
)


person_passport = Table(
    'person_passport',
    Base.metadata,
    Column(
        'person_id',
        Integer,
        ForeignKey(
            'person.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_person_id_person_passport',
        ),
        primary_key=True,
    ),
    Column(
        'passport_id',
        Integer,
        ForeignKey(
            'passport.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_passport_id_person_passport',
        ),
        primary_key=True,
    )
)


person_address = Table(
    'person_address',
    Base.metadata,
    Column(
        'person_id',
        Integer,
        ForeignKey(
            'person.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_person_id_person_address',
        ),
        primary_key=True,
    ),
    Column(
        'address_id',
        Integer,
        ForeignKey(
            'address.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_address_id_person_address',
        ),
        primary_key=True,
    )
)


class Person(Base):
    __tablename__ = 'person'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_person",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    first_name = Column(
        String(length=32),
        nullable=False,
    )
    last_name = Column(
        String(length=32),
    )
    second_name = Column(
        String(length=32),
    )
    birthday = Column(
        Date,
    )
    gender = Column(
        ENUM(
            u'male', u'female',
            name='genders_enum',
            create_type=True,
        ),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'person',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    contacts = relationship(
        'Contact',
        secondary=person_contact,
        backref=backref(
            'person',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
    )
    passports = relationship(
        'Passport',
        secondary=person_passport,
        backref=backref(
            'person',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
    )

    addresses = relationship(
        'Address',
        secondary=person_address,
        backref=backref(
            'person',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
    )

    @hybrid_property
    def name(self):
        return self.last_name + " " + self.first_name

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
