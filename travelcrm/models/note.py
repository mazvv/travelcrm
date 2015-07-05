# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


note_resource = Table(
    'note_resource',
    Base.metadata,
    Column(
        'note_id',
        Integer,
        ForeignKey(
            'note.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_note_id_note_resource',
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
            name='fk_resource_id_note_resource',
        ),
        primary_key=True,
    )
)


note_upload = Table(
    'note_upload',
    Base.metadata,
    Column(
        'note_id',
        Integer,
        ForeignKey(
            'note.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_note_id_note_upload',
        ),
        primary_key=True,
    ),
    Column(
        'upload_id',
        Integer,
        ForeignKey(
            'upload.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_upload_id_note_upload',
        ),
        primary_key=True,
    )
)


class Note(Base):
    __tablename__ = 'note'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_note",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    title = Column(
        String(255),
        nullable=False,
    )
    descr = Column(
        String,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'note',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    note_resource = relationship(
        'Resource',
        secondary=note_resource,
        backref=backref(
            'notes',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False,
    )
    uploads = relationship(
        'Upload',
        secondary=note_upload,
        backref=backref(
            'note',
            uselist=False
        ),
        cascade="all,delete",
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
