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

from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _

from ..models import (
    DBSession,
    Base
)


notification_resource = Table(
    'notification_resource',
    Base.metadata,
    Column(
        'notification_id',
        Integer,
        ForeignKey(
            'notification.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_notification_id_notification_resource',
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
            name='fk_resource_id_notification_resource',
        ),
        primary_key=True,
    )
)


class EmployeeNotification(Base):
    __tablename__ = 'employee_notification'

    STATUS = (
        ('new', _(u'new')),
        ('closed', _(u'closed')),
    )
    employee_id = Column(
        Integer,
        ForeignKey(
            'employee.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_employee_id_employee_notification',
        ),
        primary_key=True,
    )
    notification_id = Column(
        Integer,
        ForeignKey(
            'notification.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_notification_id_employee_notification',
        ),
        primary_key=True,
    )
    status = Column(
        EnumIntType(STATUS),
        default='new',
        nullable=False,
    )

    def close(self):
        self.status = 'closed'


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
    descr = Column(
        String,
        nullable=False,
    )
    url = Column(
        String,
    )
    created = Column(
        DateTime(timezone=True),
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
    notification_resource = relationship(
        'Resource',
        secondary=notification_resource,
        backref=backref(
            'notifications',
            uselist=True,
            lazy='dynamic',
        ),
        cascade='all,delete',
        uselist=False,
    )
    employees = relationship(
        'Employee',
        secondary=EmployeeNotification.__table__,
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

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )
