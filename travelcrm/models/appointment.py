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


class AppointmentHeader(Base):
    __tablename__ = 'appointment_header'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_appointment_header",
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
            'appointment',
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


class AppointmentRow(Base):
    __tablename__ = 'appointment_row'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    appointment_header_id = Column(
        Integer,
        ForeignKey(
            'appointment_header.id',
            name="fk_appointment_header_id_appointment_row",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    employee_id = Column(
        Integer,
        ForeignKey(
            'employee.id',
            name="fk_employee_id_appointment_row",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    position_id = Column(
        Integer,
        ForeignKey(
            'position.id',
            name="fk_position_id_appointment_row",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )

    header = relationship(
        'AppointmentHeader',
        backref=backref(
            'rows', uselist=True, cascade="all,delete"
        ),
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

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_employee_id(cls, employee_id):
        return cls.employee_id == employee_id
