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
