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
    __tablename__ = 'groups_permisions'
    __table_args__ = (
        Index('idx_group_permissions_permissions', 'permissions'),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resources_types_id = Column(
        Integer,
        ForeignKey(
            'resources_types.id',
            name="fk_resources_type_id_groups_permissions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    groups_id = Column(
        Integer,
        ForeignKey(
            'groups.id',
            name="fk_groups_id_groups_permissions",
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
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_by_resources_types_id(cls, resources_types_id):
        return cls.resources_types_id == resources_types_id
