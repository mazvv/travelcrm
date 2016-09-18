# -*- coding:utf-8 -*-

from zope.interface.verify import verifyClass


from sqlalchemy import (
    Integer,
    Boolean,
    DateTime,
    Column,
    ForeignKey,
    func,
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
from ..lib.utils.resources_utils import (
    get_resource_class_module,
    get_resource_class_name,
)
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
    modifydt = Column(
        DateTime(),
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

    def __repr__(self):
        return (
            "%s (id=%d, resource_type_id=%d)"
            % (self.__class__.__name__, self.id, self.resource_type_id)
        )


def update_event(mapper, connection, target):
    """
    ITS IMPORTANT! 
    we need it because in most cases insert and update resource is implicit 
    """
    target.modifydt = func.now()
 
 
event.listen(Resource, 'before_insert', update_event)
event.listen(Resource, 'before_update', update_event)
