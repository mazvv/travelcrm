# -*- coding:utf-8 -*-

from sqlalchemy import (
    Integer,
    String,
    Column,
    ForeignKey,
    desc
)
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
)


class GroupNavigation(Base):
    __tablename__ = 'groups_navigations'

    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_groups_navigations",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    groups_id = Column(
        Integer(),
        ForeignKey(
            'groups.id',
            name='fk_groups_navigations_groups_id',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'groups_navigations.id',
            name='fk_parent_id_groups_navigations',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    url = Column(
        String(length=128),
        nullable=False,
    )
    icon_cls = Column(
        String(length=32),
    )
    position = Column(
        Integer(),
        nullable=False
    )
    resource = relationship(
        'Resource',
        backref=backref('group_navigation', uselist=False),
        uselist=False
    )

    group = relationship(
        'Group',
        backref=backref(
            'group_navigations',
            uselist=True,
            lazy='dynamic',
            order_by='asc(GroupNavigation.parent_id).nullsfirst(),'
            'GroupNavigation.position',
        ),
        uselist=False
    )

    children = relationship(
        'GroupNavigation',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        order_by='GroupNavigation.position',
        lazy='dynamic'
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_root_level(cls):
        return cls.parent_id == None

    @classmethod
    def condition_parent_id(cls, parent_id):
        return cls.parent_id == parent_id

    def change_position(self, action):
        assert action in ['up', 'down'], u"Action must be 'up' or 'down'"
        query = DBSession.query(GroupNavigation)
        if action == 'up':
            group_navigation = (
                query.filter(
                    GroupNavigation.position < self.position,
                    GroupNavigation.condition_parent_id(
                        self.parent_id
                    )
                )
                .order_by(desc(GroupNavigation.position))
                .first()
            )
        else:
            group_navigation = (
                query.filter(
                    GroupNavigation.position > self.position,
                    GroupNavigation.condition_parent_id(
                        self.parent_id
                    )
                )
                .order_by(GroupNavigation.position)
                .first()
            )

        if group_navigation:
            position = group_navigation.position
            group_navigation.position = self.position
            self.position = position
