# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    UniqueConstraint,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Mail(Base):
    __tablename__ = 'mail'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_mail',
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
            name="fk_resource_id_mail",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    subject = Column(
        String(length=128),
        nullable=False,
    )
    descr = Column(
        String(255),
    )
    html_content = Column(
        Text(),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'mail',
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
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @classmethod
    def by_name(cls, name):
        return (
            DBSession.query(cls).filter(cls.name == name).first()
        )
