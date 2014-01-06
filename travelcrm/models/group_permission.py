# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    Index,
)
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class GroupPermision(Base):
    __tablename__ = '_groups_permisions'
    __table_args__ = (
        Index('idx_group_permissions_permissions', 'permissions'),
    )

    rid = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    _resources_types_rid = Column(
        Integer,
        ForeignKey(
            '_resources_types.rid',
            name="fk_resources_type_rid_groups_permissions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    _groups_rid = Column(
        Integer,
        ForeignKey(
            '_groups.rid',
            name="fk_groups_rid_groups_permissions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    permissions = Column(
        ARRAY(String),
    )

    group = relationship(
        'Group',
        backref=backref(
            'permissions',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def condition_by_resources_types_rid(cls, _resources_types_rid):
        return cls._resources_types_rid == _resources_types_rid
