# -*- coding:utf-8 -*-

from sqlalchemy import (
    Integer,
    String,
    Text,
    Column,
    UniqueConstraint,
    ForeignKey,
)
from sqlalchemy.orm import (
    synonym,
    relationship,
    backref,
)

from ..models import (
    DBSession, Base
)


class ResourceType(Base):
    __tablename__ = '_resources_types'
    __table_args__ = (
        UniqueConstraint(
            'module',
            'resource_name',
            name='unique_idx_resources_types_module',
            use_alter=True,
        ),
    )

    # column definitions
    rid = Column(
        Integer(),
        primary_key=True,
        nullable=False,
        autoincrement=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_resources_types",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
        unique=True
    )
    humanize = Column(
        String(length=32),
        nullable=False,
        unique=True
    )
    _resource = Column(
        'resource_name',
        String(length=32),
        nullable=False,
    )
    module = Column(
        String(length=128),
        nullable=False,
    )
    _settings = Column(
        u'settings',
        Text,
        primary_key=False,
        nullable=True
    )
    description = Column(
        String(length=128),
    )
    resource_obj = relationship(
        'Resource',
        backref=backref(
            'resource_type_obj', uselist=False, cascade="all,delete"
        ),
        foreign_keys=[_resources_rid],
        uselist=False
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()

    @classmethod
    def by_humanize(cls, humanize):
        return DBSession.query(cls).filter(cls.humanize == humanize).first()

    @classmethod
    def by_resource_name(cls, module, resource_name):
        return (
            DBSession.query(cls)
            .filter(
                cls.module == module,
                cls._resource == resource_name
            )
            .first()
        )

    @property
    def settings(self):
        return str(self._settings)

    @settings.setter
    def settings(self, settings):
        self._settings = settings

    @property
    def resource(self):
        return self._resource

    @resource.setter
    def resource(self, resource):
        assert isinstance(resource, (str, unicode)), type(resource)
        path = resource.split('.')
        self.module = '.'.join(path[:-1])
        self._resource = path[-1]

    @property
    def resource_full(self):
        return "%s.%s" % (self.module, self.resource)

    def __repr__(self):
        return (
            "%s (rid=%s, _resources_rid=%s, context=%s)"
            % (
               self.__class__.__name__,
               self.rid,
               self._resources_rid,
               self.resource
            )
        )

    settings = synonym('settings', descriptor=settings)
    resource = synonym('resource', descriptor=resource)
