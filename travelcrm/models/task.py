# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    DateTime,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


task_resource = Table(
    'task_resource',
    Base.metadata,
    Column(
        'task_id',
        Integer,
        ForeignKey(
            'task.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'resource_id',
        Integer,
        ForeignKey(
            'resource.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


class Task(Base):
    __tablename__ = 'task'

    PRIORITY = [
        ('minor', _(u'minor')),
        ('normal', _(u'normal')),
        ('major', _(u'major')),
        ('critical', _(u'critical'))
    ]
    STATUS = [
        ('undefined', _(u'undefined')),
        ('in_work', _(u'in work')),
        ('on_hold', _(u'on hold')),
        ('requirements', _(u'requirements')),
        ('closed', _(u'closed')),
    ]

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_task",
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
            name="fk_employee_id_task",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    title = Column(
        String(length=128),
        nullable=False,
    )
    deadline = Column(
        Date,
        nullable=False,
    )
    reminder = Column(
        DateTime,
    )
    descr = Column(
        String,
    )
    priority = Column(
        EnumIntType(PRIORITY),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref('task', uselist=False, cascade="all,delete"),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    task_resource = relationship(
        'Resource',
        secondary=task_resource,
        backref=backref('resource_task', uselist=False),
        cascade="all,delete",
        uselist=True,
    )
    employee = relationship(
        'Employee',
        backref=backref(
            'tasks',
            uselist=True,
            cascade='all,delete',
            lazy="dynamic"
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @property
    def reminder_date(self):
        if self.reminder:
            return self.reminder.date()

    @property
    def reminder_time(self):
        if self.reminder:
            return self.reminder.time()
