# -*- coding:utf-8 -*-

from sqlalchemy import (
    Integer,
    Boolean,
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


class Navigation(Base):
    __tablename__ = 'navigation'

    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_navigation",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    position_id = Column(
        Integer(),
        ForeignKey(
            'position.id',
            name='fk_navigation_position_id',
            onupdate='cascade',
            ondelete='restrict',
        )
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'navigation.id',
            name='fk_parent_id_navigation',
            onupdate='cascade',
            ondelete='restrict',
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
    action = Column(
        String(length=32),
    )
    icon_cls = Column(
        String(length=32),
    )
    separator_before = Column(
        Boolean(),
        default=False,
    )
    sort_order = Column(
        Integer(),
        nullable=False
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'navigation',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )
    position = relationship(
        'Position',
        backref=backref(
            'navigations',
            uselist=True,
            lazy='dynamic',
            order_by='asc(Navigation.parent_id).nullsfirst(),'
            'Navigation.sort_order',
        ),
        uselist=False
    )

    children = relationship(
        'Navigation',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        order_by='Navigation.sort_order',
        lazy='dynamic'
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @classmethod
    def condition_root_level(cls):
        return cls.parent_id == None

    @classmethod
    def condition_parent_id(cls, parent_id):
        return cls.parent_id == parent_id

    @classmethod
    def condition_position_id(cls, position_id):
        return cls.position_id == position_id

    def change_sort_order(self, action):
        assert action in ['up', 'down'], u"Action must be 'up' or 'down'"
        query = DBSession.query(Navigation)
        if action == 'up':
            navigation = (
                query.filter(
                    Navigation.sort_order < self.sort_order,
                    Navigation.condition_parent_id(
                        self.parent_id
                    )
                )
                .order_by(desc(Navigation.sort_order))
                .first()
            )
        else:
            navigation = (
                query.filter(
                    Navigation.sort_order > self.sort_order,
                    Navigation.condition_parent_id(
                        self.parent_id
                    )
                )
                .order_by(Navigation.sort_order)
                .first()
            )

        if navigation:
            sort_order = navigation.sort_order
            navigation.sort_order = self.sort_order
            self.sort_order = sort_order
