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
from ..models.user import User


class ResourceLog(Base):
    __tablename__ = 'resources_logs'

    # column definitions
    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resources_id = Column(
        Integer(),
        ForeignKey(
            'resources.id',
            name='fk_resources_id_resources_log',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False
    )
    modifier_id = Column(
        Integer(),
        ForeignKey('users.id',
            name='fk_modifier_users_id_resources_log',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False
    )
    comment = Column(
        String(512),
    )
    modifydt = Column(
        DateTime(timezone=False),
        default=func.now()
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'resources_logs',
            uselist=True,
            cascade="all,delete",
            lazy='dynamic'
        ),
        cascade="all,delete",
        uselist=False,
    )

    modifier = relationship(
        'User',
        primaryjoin='ResourceLog.modifier_id==User.id',
        backref=backref(
            'resources_logs',
            uselist=True,
            lazy='dynamic'
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
            .group_by(cls.resources_id)
            .subquery()
        )
        max_entries_query = (
            DBSession.query(
                cls.resources_id.label('id'),
                cls.modifydt,
                User.resources_id.label('modifier_resource_id'),
                User.username.label('modifier'),
            )
            .join(User, cls.modifier)
            .filter(cls.id.in_(max_entries_subquery))
        )
        return max_entries_query
