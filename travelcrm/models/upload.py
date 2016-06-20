# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Numeric,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Upload(Base):
    __tablename__ = 'upload'
    __table_args__ = (
        UniqueConstraint(
            'path',
            name='unique_idx_path_upload',
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
            name="fk_resource_id_contact",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=255),
        nullable=False,
    )
    path = Column(
        String(length=255),
        nullable=False,
    )
    size = Column(
        Numeric(16, 2),
        nullable=False,
    )
    media_type = Column(
        String(length=128),
        nullable=False,
    )
    descr = Column(
        String(255),
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'upload',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_path(cls, path):
        return DBSession.query(cls).filter(cls.path == path).first()

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )
