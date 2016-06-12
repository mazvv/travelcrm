# -*- coding:utf-8 -*-

from sqlalchemy import (
    Integer,
    DateTime,
    String,
    Column,
    ForeignKey,
    func
)
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
)
from ..models.employee import Employee


class ResourceLog(Base):
    __tablename__ = 'resource_log'

    # column definitions
    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resource_id = Column(
        Integer(),
        ForeignKey(
            'resource.id',
            name='fk_resource_id_resource_log',
            onupdate='cascade',
            ondelete='cascade',
        ),
        nullable=False
    )
    employee_id = Column(
        Integer(),
        ForeignKey('employee.id',
            name='fk_employee_id_resource_log',
            onupdate='cascade',
            ondelete='cascade',
        ),
        nullable=False
    )
    comment = Column(
        String(512),
    )
    modifydt = Column(
        DateTime(timezone=True),
        default=func.now()
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'resources_logs',
            uselist=True,
            cascade="all,delete",
            order_by=modifydt,
            lazy='dynamic'
        ),
        cascade="all,delete",
        uselist=False,
    )

    modifier = relationship(
        'Employee',
        backref=backref(
            'resources_logs',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def query_last_max_entries(cls):
        max_entries_subquery = (
            DBSession.query(
                func.max(cls.id)
            )
            .group_by(cls.resource_id)
            .subquery()
        )
        max_entries_query = (
            DBSession.query(
                cls.resource_id.label('id'),
                cls.modifydt,
                Employee.name.label('modifier'),
                Employee.id.label('modifier_id'),
            )
            .join(Employee, cls.modifier)
            .filter(cls.id.in_(max_entries_subquery))
        )
        return max_entries_query
