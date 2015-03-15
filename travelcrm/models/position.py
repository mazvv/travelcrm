# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
)


class Position(Base):
    __tablename__ = 'position'
    __table_args__ = (
        UniqueConstraint(
            'name',
            'structure_id',
            name='unique_idx_name_strcuture_id_position',
        ),
    )

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_position",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    structure_id = Column(
        Integer(),
        ForeignKey(
            'structure.id',
            name='fk_position_structure_id',
            onupdate='cascade',
            ondelete='restrict',
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'position',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )

    structure = relationship(
        'Structure',
        backref=backref(
            'positions',
            uselist=True,
        ),
        uselist=False
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
    def condition_structure_id(cls, structure_id):
        return cls.structure_id == structure_id
