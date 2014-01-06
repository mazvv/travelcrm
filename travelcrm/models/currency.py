# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey
    )
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    Base,
    DBSession
)


class Currency(Base):
    __tablename__ = '_currencies'

    rid = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_currencies",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    iso_code = Column(
        String(length=3),
        nullable=False,
        unique=True
    )
    name = Column(
        String(length=32),
        nullable=False
    )

    resource = relationship(
        'Resource',
        backref=backref('currency', uselist=False),
        uselist=False
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def by_resource_rid(cls, rid):
        return DBSession.query(cls).filter(cls._resources_rid == rid).first()

    @classmethod
    def by_code(cls, code):
        return DBSession.query(cls).filter(cls.code == code).first()

