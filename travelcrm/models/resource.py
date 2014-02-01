# -*- coding:utf-8 -*-

from collections import namedtuple
from zope.interface.verify import verifyClass

from pyramid import threadlocal

from sqlalchemy import (
    Integer,
    Column,
    ForeignKey,
    event,
)
from sqlalchemy.orm import (
    relationship,
    backref,
)

from pyramid.security import authenticated_userid

from ..models import (
    DBSession,
    Base
)
from ..models.resource_type import ResourceType
from ..models.resource_log import ResourceLog
from ..models.user import User
from ..lib.resources_utils import (
    get_resource_class_module,
    get_resource_class_name,
)
from ..interfaces import IResource


_statuses = {
    0: 'active',
    1: 'disabled',
    3: 'draft',
    4: 'error',
    5: 'archive',
}

_STATUS = namedtuple('STATUS', _statuses.values())(*_statuses.keys())


class Resource(Base):
    __tablename__ = 'resources'

    STATUS = _STATUS

    # column definitions
    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resources_types_id = Column(
        Integer(),
        ForeignKey(
            'resources_types.id',
            name='fk_resources_types_id_resources',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False
    )
    owner_id = Column(
        Integer(),
        ForeignKey('users.id',
            name='fk_owner_id_resources',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False
    )
    status = Column(
        Integer(),
        default=STATUS.active
    )

    resource_type = relationship(
        'ResourceType',
        backref=backref('resources', uselist=True, lazy='dynamic'),
        foreign_keys=[resources_types_id],
        uselist=False
    )
    owner = relationship(
        'User',
        backref=backref('resources', uselist=True, lazy='dynamic'),
        foreign_keys=[owner_id],
        uselist=False
    )

    def __init__(self, resource_type_cls, status=0):
        assert verifyClass(IResource, resource_type_cls), \
            type(resource_type_cls)

        resource_cls_module = get_resource_class_module(resource_type_cls)
        resource_cls_name = get_resource_class_name(resource_type_cls)
        self.resource_type = ResourceType.by_resource_name(
            resource_cls_module, resource_cls_name
        )
        self.status = status

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    def is_active(self):
        return self.status == Resource.STATUS.active

    def set_status_active(self):
        self.status = Resource.STATUS.active

    def set_status_disabled(self):
        self.status = Resource.STATUS.disabled

    def set_status_draft(self):
        self.status = Resource.STATUS.draft

    def set_status_error(self):
        self.status = Resource.STATUS.error

    @classmethod
    def condition_active(cls):
        return cls.status == cls.STATUS.active

    @classmethod
    def condition_non_disabled_or_draft(cls):
        return ~cls.status.in_([cls.STATUS.draft, cls.STATUS.disabled])

    def logging(self):
        request = threadlocal.get_current_request()
        users_id = authenticated_userid(request)
        modifier = User.get(users_id)
        assert modifier is not None, type(modifier)
        self.resources_logs.append(
            ResourceLog(
                modifier=modifier,
            )
        )

    def __repr__(self):
        return (
            "%s (id=%d, resources_types_id=%d)"
            % (self.__class__.__name__, self.id, self.resources_types_id)
        )


def logging_event(mapper, connection, target):
    target.logging()

event.listen(Resource, 'after_insert', logging_event)
event.listen(Resource, 'after_update', logging_event)
