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


class PositionNavigation(Base):
    __tablename__ = 'positions_navigations'

    id = Column(
        Integer(),
        primary_key=True,
        autoincrement=True,
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_positions_navigations",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    companies_positions_id = Column(
        Integer(),
        ForeignKey(
            'companies_positions.id',
            name='fk_positions_navigations_companies_positions_id',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'positions_navigations.id',
            name='fk_parent_id_positions_navigations',
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
        backref=backref(
            'position_navigation',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )
    company_position = relationship(
        'CompanyPosition',
        backref=backref(
            'positions_navigations',
            uselist=True,
            lazy='dynamic',
            order_by='asc(PositionNavigation.parent_id).nullsfirst(),'
            'PositionNavigation.position',
        ),
        uselist=False
    )

    children = relationship(
        'PositionNavigation',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        order_by='PositionNavigation.position',
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

    @classmethod
    def condition_company_position_id(cls, companies_positions_id):
        return cls.companies_positions_id == companies_positions_id

    def change_position(self, action):
        assert action in ['up', 'down'], u"Action must be 'up' or 'down'"
        query = DBSession.query(PositionNavigation)
        if action == 'up':
            position_navigation = (
                query.filter(
                    PositionNavigation.position < self.position,
                    PositionNavigation.condition_parent_id(
                        self.parent_id
                    )
                )
                .order_by(desc(PositionNavigation.position))
                .first()
            )
        else:
            position_navigation = (
                query.filter(
                    PositionNavigation.position > self.position,
                    PositionNavigation.condition_parent_id(
                        self.parent_id
                    )
                )
                .order_by(PositionNavigation.position)
                .first()
            )

        if position_navigation:
            position = position_navigation.position
            position_navigation.position = self.position
            self.position = position
