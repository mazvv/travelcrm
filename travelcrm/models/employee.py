# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
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


employee_upload = Table(
    'employee_upload',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_upload',
        ),
        primary_key=True,
    ),
    Column(
        'upload_id',
        Integer,
        ForeignKey(
            'upload.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_upload_id_employee_upload',
        ),
        primary_key=True,
    )
)


employee_subscription = Table(
    'employee_subscription',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_subscription',
        ),
        primary_key=True,
    ),
    Column(
        'resource_id',
        Integer,
        ForeignKey(
            'resource.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_resource_id_employee_subscription',
        ),
        primary_key=True,
    )
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
    photo_upload_id = Column(
        Integer,
        ForeignKey(
            'upload.id',
            name="fk_photo_upload_id_employee",
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
        nullable=False,
    )
    second_name = Column(
        String(length=32),
    )
    itn = Column(
        String(length=32),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'employee',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        foreign_keys=[resource_id],
        uselist=False,
    )
    photo = relationship(
        'Upload',
        cascade="all,delete",
        uselist=False,
    )
    uploads = relationship(
        'Upload',
        secondary=employee_upload,
        backref=backref(
            'employee',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
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
    subaccounts = relationship(
        'Subaccount',
        secondary=employee_subaccount,
        backref=backref(
            'employee',
            uselist=False,
        ),
        cascade="all,delete",
        uselist=True,
    )
    subscriptions = relationship(
        'Resource',
        secondary=employee_subscription,
        backref=backref(
            'subscribers',
            lazy='dynamic',
            uselist=True,
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

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )
