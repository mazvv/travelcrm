# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Numeric,
    UniqueConstraint,
)

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
    path = Column(
        String(length=255),
        nullable=False,
    )
    size = Column(
        Numeric(16, 2),
        nullable=False,
    )
    media_type = Column(
        String(length=32),
        nullable=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_path(cls, path):
        return DBSession.query(cls).filter(cls.path == path).first()
