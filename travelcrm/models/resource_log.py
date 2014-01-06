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
    __tablename__ = '_resources_logs'

    # column definitions
    rid = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    _resources_rid = Column(
        Integer(),
        ForeignKey(
            '_resources.rid',
            name='fk_resources_rid_resources_log',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False
    )
    modifier_users_rid = Column(
        Integer(),
        ForeignKey('_users.rid',
            name='fk_modifier_users_rid_resources_log',
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
        primaryjoin='ResourceLog.modifier_users_rid==User.rid',
        backref=backref(
            'resources_logs',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False,
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def query_last_max_entries(cls):
        max_entries_subquery = (
            DBSession.query(
                func.max(cls.rid)
            )
            .group_by(cls._resources_rid)
            .subquery()
        )
        max_entries_query = (
            DBSession.query(
                cls._resources_rid.label('rid'),
                cls.modifydt,
                User._resources_rid.label('modifier_resource_rid'),
                User.username.label('modifier'),
            )
            .join(User, cls.modifier)
            .filter(cls.rid.in_(max_entries_subquery))
        )
        return max_entries_query
