# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    ForeignKey,
    func
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class EmployeeAppointmentHeader(Base):
    __tablename__ = 'employees_appointments_headers'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_employees_appointments_headers",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    appointment_date = Column(
        Date,
        default=func.now()
    )
    resource = relationship(
        'Resource',
        backref=backref('employee', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)


class EmployeeAppointmentRows(Base):
    __tablename__ = 'employees_appointments_rows'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    employees_id = Column(
        Integer,
    )
    companies_structures_id = Column(
        Integer,
    )

    header = relationship(
        'EmployeeAppointmentHeader',
        backref=backref(
            'rows', uselist=False, cascade="all,delete"
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
