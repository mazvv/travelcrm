# -*-coding: utf-8-*-

from datetime import datetime

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


employee_contact = Table(
    'employee_contact',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_contact',
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
            name='fk_contact_id_employee_contact',
        ),
        primary_key=True,
    )
)


employee_passport = Table(
    'employee_passport',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_passport',
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
            name='fk_passport_id_employee_passport',
        ),
        primary_key=True,
    )
)


employee_address = Table(
    'employee_address',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_address',
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
            name='fk_address_id_employee_address',
        ),
        primary_key=True,
    )
)


employee_subaccount = Table(
    'employee_subaccount',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_subaccount',
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
            name='fk_subaccount_id_employee_subaccount',
        ),
        primary_key=True,
    ),
)


class Employee(Base):
    __tablename__ = 'employee'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_employee",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    photo = Column(
        String,
    )
    first_name = Column(
        String(length=32),
        nullable=False,
    )
    last_name = Column(
        String(length=32),
        nullable=False,
    )
    second_name = Column(
        String(length=32),
    )
    itn = Column(
        String(length=32),
    )
    dismissal_date = Column(
        Date,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'employee',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    contacts = relationship(
        'Contact',
        secondary=employee_contact,
        backref=backref(
            'employee',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
    )
    passports = relationship(
        'Passport',
        secondary=employee_passport,
        backref=backref(
            'employee',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
    )
    addresses = relationship(
        'Address',
        secondary=employee_address,
        backref=backref(
            'employee',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
    )
    subaccount = relationship(
        'Subaccount',
        secondary=employee_subaccount,
        backref=backref(
            'employee',
            uselist=False,
        ),
        uselist=False,
    )

    @hybrid_property
    def name(self):
        return self.last_name + " " + self.first_name

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    def is_currently_dismissed(self):
        return (
            self.dismissal_date != None
            and self.dismissal_date < datetime.now()
        )
