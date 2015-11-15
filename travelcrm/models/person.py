# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    Date,
    Table,
    ForeignKey,
    and_
)
from sqlalchemy.orm import relationship, backref
from sqlalchemy.sql.expression import case
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


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


person_subaccount = Table(
    'person_subaccount',
    Base.metadata,
    Column(
        'person_id',
        Integer,
        ForeignKey(
            'person.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_person_id_person_subaccount',
        ),
        primary_key=True,
    ),
    Column(
        'subaccount_id',
        Integer,
        ForeignKey(
            'subaccount.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_subaccount_id_person_subaccount',
        ),
        primary_key=True,
    ),
)


class Person(Base):
    __tablename__ = 'person'

    GENDER = (
        ('male', _(u'male')),
        ('female', _(u'female')),
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
            name="fk_resource_id_person",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    person_category_id = Column(
        Integer,
        ForeignKey(
            'person_category.id',
            name="fk_person_category_id_person",
            ondelete='restrict',
            onupdate='cascade',
        ),
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
        EnumIntType(GENDER),
    )
    email_subscription = Column(
        Boolean,
        default=False,
    )
    sms_subscription = Column(
        Boolean,
        default=False,
    )
    descr = Column(
        String(length=255),
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
    person_category = relationship(
        'PersonCategory',
        backref=backref(
            'persons',
            lazy='dynamic',
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
    subaccounts = relationship(
        'Subaccount',
        secondary=person_subaccount,
        backref=backref(
            'person',
            uselist=False,
        ),
        cascade="all,delete",
        uselist=True,
    )

    @hybrid_property
    def name(self):
        return " ".join(filter(None, [self.last_name, self.first_name]))

    @name.expression
    def name(cls):
        return case(
            [(
                and_(cls.last_name != None, cls.last_name != ""), 
                cls.last_name + " " + cls.first_name
            )],
            else_=cls.first_name
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

    @classmethod
    def condition_email_subscribtion(cls):
        return cls.email_subscription == True

    @classmethod
    def condition_sms_subscribtion(cls):
        return cls.sms_subscription == True
