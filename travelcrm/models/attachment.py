# -*-coding: utf-8 -*-

from travelcrm.models import (
    Base, 
    DBSession
)

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref


class Attachment(Base):
    __tablename__ = '_attachments'

    rid = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_attachments",
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
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()
