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
from ..models.structure import Structure
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
    structure_id = Column(
        Integer(),
        ForeignKey('structure.id',
            name='fk_structure_id_resource',
            onupdate='cascade',
            ondelete='restrict',
            use_alter=True,
        ),
        nullable=False
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
    owner_structure = relationship(
        'Structure',
        backref=backref(
            'resources',
            uselist=True,
            lazy='dynamic'
        ),
        foreign_keys=[structure_id],
        uselist=False
    )

    def __init__(self, resource_type_cls, owner_structure):
        assert verifyClass(IResourceType, resource_type_cls), \
            type(resource_type_cls)
        assert isinstance(owner_structure, Structure), type(owner_structure)
        resource_cls_module = get_resource_class_module(resource_type_cls)
        resource_cls_name = get_resource_class_name(resource_type_cls)
        self.resource_type = ResourceType.by_resource_name(
            resource_cls_module, resource_cls_name
        )
        self.owner_structure = owner_structure

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    def logging(self):
        request = threadlocal.get_current_request()
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
