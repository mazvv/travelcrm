# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    DateTime,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


task_resource = Table(
    'task_resource',
    Base.metadata,
    Column(
        'task_id',
        Integer,
        ForeignKey(
            'task.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_task_id_task_resource',
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
            name='fk_resource_id_task_resource',
        ),
        primary_key=True,
    )
)


class Task(Base):
    __tablename__ = 'task'

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
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    employee_id = Column(
        Integer,
        ForeignKey(
            'employee.id',
            name="fk_employee_id_task",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    title = Column(
        String(length=128),
        nullable=False,
    )
    deadline = Column(
        DateTime,
        nullable=False,
    )
    reminder = Column(
        DateTime,
    )
    descr = Column(
        String,
    )
    closed = Column(
        Boolean,
        default=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'task',
            uselist=False,
            cascade="all,delete"
        ),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    task_resource = relationship(
        'Resource',
        secondary=task_resource,
        backref=backref(
            'tasks',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False,
    )
    employee = relationship(
        'Employee',
        backref=backref(
            'tasks',
            uselist=True,
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
