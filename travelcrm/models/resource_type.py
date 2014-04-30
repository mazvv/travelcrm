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
    DBSession,
    Base
)
from ..lib.utils.common_utils import translate as _


class ResourceType(Base):
    __tablename__ = 'resource_type'
    __table_args__ = (
        UniqueConstraint(
            'module',
            'resource_name',
            name='unique_idx_resource_type_module',
            use_alter=True,
        ),
        UniqueConstraint(
            'name',
            name='unique_idx_resource_type_name',
            use_alter=True,
        ),
    )

    STATUS = [
        ('undefined', _(u'undefined')),
        ('disabled', _(u'disabled')),
    ]

    id = Column(
        Integer(),
        primary_key=True,
        nullable=False,
        autoincrement=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_resource_type",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    humanize = Column(
        String(length=32),
        nullable=False,
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
            'resource_type_obj',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        foreign_keys=[resource_id],
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

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
            "%s (id=%s, resource_id=%s, context=%s)"
            % (
               self.__class__.__name__,
               self.id,
               self.resource_id,
               self.resource
            )
        )

    settings = synonym('settings', descriptor=settings)
    resource = synonym('resource', descriptor=resource)
