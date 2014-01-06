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
    Base,
    DBSession
)


class Region(Base):
    __tablename__ = '_regions'

    rid = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_regions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    _regions_rid = Column(
        Integer(),
        ForeignKey(
            '_regions.rid',
            name='fk_regions_regions_rid',
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
            remote_side=[rid]
        ),
        uselist=True,
        order_by='Region.name',
        lazy='dynamic'
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def by_resource_rid(cls, rid):
        return DBSession.query(cls).filter(cls._resources_rid == rid).first()
