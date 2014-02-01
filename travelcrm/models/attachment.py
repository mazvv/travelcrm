# -*-coding: utf-8 -*-

from ..models import (
    DBSession,
    Base
)

from sqlalchemy import (
    Column,
    Integer,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref


class Attachment(Base):
    __tablename__ = 'attachments'

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_attachments",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref('attachment', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False
    )

    @classmethod
    def get(cls, id):
        return DBSession.query(cls).get(id)
