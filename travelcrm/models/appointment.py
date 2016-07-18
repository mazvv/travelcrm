# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    ForeignKey,
    func
)
from sqlalchemy.orm import relationship, backref
from sqlalchemy.orm import make_transient

from ..models import (
    DBSession,
    Base
)


class Appointment(Base):
    __tablename__ = 'appointment'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_appointment",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    date = Column(
        Date,
        default=func.now()
    )
    employee_id = Column(
        Integer,
        ForeignKey(
            'employee.id',
            name="fk_employee_id_appointment",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    position_id = Column(
        Integer,
        ForeignKey(
            'position.id',
            name="fk_position_id_appointment",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    salary = Column(
        Numeric(16, 2),
        nullable=False
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_appointment",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'appointment',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    employee = relationship(
        'Employee',
        backref=backref(
            'appointments',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False
    )
    position = relationship(
        'Position',
        backref=backref(
            'appointments',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'appointments',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False
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
    def condition_employee_id(cls, employee_id):
        return cls.employee_id == employee_id
