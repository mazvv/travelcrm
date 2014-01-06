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
    __tablename__ = '_groups_navigations'

    # column definitions
    rid = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_groups_navigations",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    _groups_rid = Column(
        Integer(),
        ForeignKey(
            '_groups.rid',
            name='fk_groups_navigations_groups_rid',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )
    _groups_navigations_rid = Column(
        Integer(),
        ForeignKey(
            '_groups_navigations.rid',
            name='fk_groups_navigations_groups_navigations_rid',
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
            order_by='asc(GroupNavigation._groups_navigations_rid)\
            .nullsfirst(), GroupNavigation.position',
        ),
        uselist=False
    )

    children = relationship(
        'GroupNavigation',
        backref=backref(
            'parent',
            remote_side=[rid]
        ),
        uselist=True,
        order_by='GroupNavigation.position',
        lazy='dynamic'
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def by_resource_rid(cls, rid):
        return DBSession.query(cls).filter(cls._resources_rid == rid).first()

    @classmethod
    def condition_root_level(cls):
        return cls._groups_navigations_rid == None

    @classmethod
    def condition_parent_rid(cls, _groups_navigations_rid):
        return cls._groups_navigations_rid == _groups_navigations_rid

    def change_position(self, action):
        assert action in ['up', 'down'], u"Action must be 'up' or 'down'"
        query = DBSession.query(GroupNavigation)
        if action == 'up':
            group_navigation = (
                query.filter(
                    GroupNavigation.position < self.position,
                    GroupNavigation.condition_parent_rid(
                        self._groups_navigations_rid
                    )
                )
                .order_by(desc(GroupNavigation.position))
                .first()
            )
        else:
            group_navigation = (
                query.filter(
                    GroupNavigation.position > self.position,
                    GroupNavigation.condition_parent_rid(
                        self._groups_navigations_rid
                    )
                )
                .order_by(GroupNavigation.position)
                .first()
            )

        if group_navigation:
            position = group_navigation.position
            group_navigation.position = self.position
            self.position = position
            DBSession.add(group_navigation)
            DBSession.add(self)
