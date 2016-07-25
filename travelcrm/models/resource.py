# -*- coding:utf-8 -*-

from zope.interface.verify import verifyClass

from pyramid import threadlocal

from sqlalchemy import (
    Integer,
    Boolean,
    Column,
    ForeignKey,
    event,
)
from sqlalchemy.orm import (
    relationship,
    backref,
)

from ..models import (
    DBSession,
    Base
)
from ..models.resource_type import ResourceType
from ..models.resource_log import ResourceLog
from ..lib.utils.resources_utils import (
    get_resource_class_module,
    get_resource_class_name,
)
from ..lib.utils.security_utils import get_auth_employee
from ..interfaces import IResourceType


class Resource(Base):
    __tablename__ = 'resource'

    # column definitions
    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resource_type_id = Column(
        Integer(),
        ForeignKey(
            'resource_type.id',
            name='fk_resource_type_id_resource',
            onupdate='cascade',
            ondelete='restrict',
            use_alter=True,
        ),
        nullable=False
    )
    maintainer_id = Column(
        Integer(),
        ForeignKey('employee.id',
            name='fk_maintainer_id_resource',
            onupdate='cascade',
            ondelete='restrict',
            use_alter=True,
        )
    )
    protected = Column(
        Boolean,
        default=False,
    )

    resource_type = relationship(
        'ResourceType',
        backref=backref(
            'resources',
            uselist=True,
            lazy='dynamic'
        ),
        foreign_keys=[resource_type_id],
        uselist=False
    )
    maintainer = relationship(
        'Employee',
        backref=backref(
            'maintained_resources',
            uselist=True,
            lazy='dynamic'
        ),
        foreign_keys=[maintainer_id],
        uselist=False,
        post_update=True,
    )

    def __init__(self, resource_type_cls, maintainer):
        assert verifyClass(IResourceType, resource_type_cls), \
            type(resource_type_cls)
        resource_cls_module = get_resource_class_module(resource_type_cls)
        resource_cls_name = get_resource_class_name(resource_type_cls)
        self.resource_type = ResourceType.by_resource_name(
            resource_cls_module, resource_cls_name
        )
        self.maintainer = maintainer

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @property
    def creator(self):
        rl = self.resources_logs.first()
        if rl:
            return rl.modifier

    @property
    def last_modifier(self):
        rl = self.resources_logs[-1]
        if rl:
            return rl.modifier

    def logging(self):
        request = threadlocal.get_current_request()
        if not request:
            return
        modifier = get_auth_employee(request)
        assert modifier is not None, type(modifier)
        self.resources_logs.append(
            ResourceLog(
                modifier=modifier,
            )
        )

    def __repr__(self):
        return (
            "%s (id=%d, resource_type_id=%d)"
            % (self.__class__.__name__, self.id, self.resource_type_id)
        )


def logging_event(mapper, connection, target):
    target.logging()

event.listen(Resource, 'after_insert', logging_event)
event.listen(Resource, 'after_update', logging_event)
