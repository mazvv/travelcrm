# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Permision(Base):
    __tablename__ = 'permision'
    __table_args__ = (
        UniqueConstraint(
            'resource_type_id',
            'position_id',
            name='unique_idx_resource_type_id_position_id_permision'
        ),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_type_id = Column(
        Integer,
        ForeignKey(
            'resource_type.id',
            name="fk_resource_type_id_permission",
            ondelete='cascade',
            onupdate='cascade',
        ),
        nullable=False,
    )
    position_id = Column(
        Integer,
        ForeignKey(
            'position.id',
            name="fk_position_id_permision",
            ondelete='cascade',
            onupdate='cascade',
        ),
        nullable=False,
    )
    permisions = Column(
        ARRAY(String),
    )
    scope_type = Column(
        String
    )
    structure_id = Column(
        Integer,
        ForeignKey(
            'structure.id',
            name='fk_permision_structure_id',
            onupdate='cascade',
            ondelete='restrict',
        )
    )

    position = relationship(
        'Position',
        backref=backref(
            'permisions',
            uselist=True,
            lazy='dynamic',
            cascade='all, delete-orphan'
        ),
        uselist=False
    )
    resource_type = relationship(
        'ResourceType',
        backref=backref(
            'resource_type_permisions',
            uselist=True,
            lazy='dynamic',
            cascade='all, delete-orphan'
        ),
        uselist=False
    )
    structure = relationship(
        'Structure',
        backref=backref(
            'permisions',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_position_id(cls, position_id):
        return cls.position_id == position_id

    @classmethod
    def condition_resource_type_id(cls, resource_type_id):
        return cls.resource_type_id == resource_type_id
