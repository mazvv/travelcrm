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


_users_groups = Table(
    '_users_groups',
    Base.metadata,
    Column(
        '_users_rid',
        Integer,
        ForeignKey(
            '_users.rid',
            name="fk_users_rid",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        primary_key=True
    ),
    Column(
        '_groups_rid',
        Integer,
        ForeignKey(
            '_groups.rid',
            name="fk_groups_rid",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True
        ),
        primary_key=True
    ),
)


class User(Base):
    __tablename__ = '_users'

    rid = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_users",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    username = Column(
        String(length=32),
        nullable=False,
        unique=True
    )
    email = Column(
        String(length=128),
        nullable=True,
        unique=True
    )
    password = Column(
        String(length=128),
        nullable=False
    )

    groups = relationship(
        'Group',
        secondary=_users_groups,
        backref=backref('users', order_by='User.username'),
        order_by='Group.name',
        lazy='dynamic'
    )

    resource = relationship(
        'Resource',
        backref=backref('user', uselist=False),
        foreign_keys=[_resources_rid],
        uselist=False
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def by_username(cls, username):
        return DBSession.query(cls).filter(cls.username == username).first()

    @classmethod
    def by_email(cls, email):
        return DBSession.query(cls).filter(cls.email == email).first()

    def validate_password(self, password):
        return self.password == password
