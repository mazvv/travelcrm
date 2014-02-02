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


class EmployeeAppointmentH(Base):
    __tablename__ = 'employees_appointments_h'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_employees_appointments_h",
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
        backref=backref(
            'employee_appointment',
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


class EmployeeAppointmentR(Base):
    __tablename__ = 'employees_appointments_r'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    employees_appointments_h_id = Column(
        Integer,
        ForeignKey(
            'employees_appointments_h.id',
            name="fk_employees_appointments_h_id_employees_appointments_r",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    employees_id = Column(
        Integer,
        ForeignKey(
            'employees.id',
            name="fk_employees_id_employees_appointments_r",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    companies_positions_id = Column(
        Integer,
        ForeignKey(
            'companies_positions.id',
            name="fk_companies_positions_id_employees_appointments_r",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )

    header = relationship(
        'EmployeeAppointmentH',
        backref=backref(
            'rows', uselist=True, cascade="all,delete"
        ),
        uselist=False,
    )
    employee = relationship(
        'Employee',
        backref=backref(
            'employees_appointments',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False
    )
    company_position = relationship(
        'CompanyPosition',
        backref=backref(
            'employees_appointments',
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
    def condition_employee_id(cls, employee_id):
        return cls.employees_id == employee_id
