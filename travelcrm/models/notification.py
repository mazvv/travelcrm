# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    ForeignKey,
    Table,
    func,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


employee_notification = Table(
    'employee_notification',
    Base.metadata,
    Column(
        'employee_id',
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_notification',
        ),
        primary_key=True,
    ),
    Column(
        'notification_id',
        Integer,
        ForeignKey(
            'notification.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_contact_id_employee_notification',
        ),
        primary_key=True,
    )
)


class Notification(Base):
    __tablename__ = 'notification'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_notification",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    title = Column(
        String,
        nullable=False,
    )
    descr = Column(
        String,
        nullable=False,
    )
    url = Column(
        String,
    )
    created = Column(
        DateTime,
        default=func.now(),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'notification',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    employees = relationship(
        'Employee',
        secondary=employee_notification,
        backref=backref(
            'notifications',
            uselist=True,
            lazy='dynamic'
        ),
        cascade="all,delete",
        uselist=True,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
