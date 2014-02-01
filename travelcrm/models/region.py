# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    )

from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
)


class Region(Base):
    __tablename__ = 'regions'

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_regions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'regions.id',
            name='fk_regions_parent_id',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )
    name = Column(
        String(length=32),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref('region', uselist=False),
        uselist=False
    )

    children = relationship(
        'Region',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        order_by='Region.name',
        lazy='dynamic'
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
