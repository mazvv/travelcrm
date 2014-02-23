# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Boolean,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


class TAppointmentRow(Base):
    __tablename__ = '_tappointment_row'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    temporal_id = Column(
        Integer,
        ForeignKey(
            '_temporal.id',
            name="fk_temporal_id_temporal_id",
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
            name="fk_employee_id_tappointment_row",
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
            name="fk_position_id_tappointment_row",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    deleted = Column(
        Boolean,
        default=False,
    )
    main_id = Column(
        Integer,
        ForeignKey(
            'appointment_row.id',
            name="fk_main_id_appointment_row_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
    )

    temporal = relationship(
        'Temporal',
        backref=backref(
            'tappointment_rows',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic",
        ),
        uselist=False,
    )
    main = relationship(
        'AppointmentRow',
        backref=backref(
            'temporals',
            uselist=True,
            cascade="all,delete"
        ),
        uselist=False,
    )
    employee = relationship(
        'Employee',
        backref=backref(
            'tappointments',
            uselist=True,
            cascade="all,delete",
            lazy='dynamic'
        ),
        uselist=False
    )
    position = relationship(
        'Position',
        backref=backref(
            'tappointments',
            uselist=True,
            cascade="all,delete",
            lazy='dynamic'
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
