# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    Table,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


tag_resource = Table(
    'tag_resource',
    Base.metadata,
    Column(
        'tag_id',
        Integer,
        ForeignKey(
            'tag.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_tag_id_tag_resource',
        ),
        primary_key=True,
    ),
    Column(
        'resource_id',
        Integer,
        ForeignKey(
            'resource.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_resource_id_tag_resource',
        ),
        primary_key=True,
    )
)


class Tag(Base):
    __tablename__ = 'tag'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_tag',
        ),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_tag",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=255),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'tag',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    tag_resources = relationship(
        'Resource',
        secondary=tag_resource,
        backref=backref(
            'tags',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=True,
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
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
