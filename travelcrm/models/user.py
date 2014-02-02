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


users_groups = Table(
    'users_groups',
    Base.metadata,
    Column(
        'users_id',
        Integer,
        ForeignKey(
            'users.id',
            name="fk_users_groups_users_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        primary_key=True
    ),
    Column(
        'groups_id',
        Integer,
        ForeignKey(
            'groups.id',
            name="fk_users_groups_groups_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True
        ),
        primary_key=True
    ),
)


class User(Base):
    __tablename__ = 'users'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_users",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    employees_id = Column(
        Integer,
        ForeignKey(
            'employees.id',
            name="fk_employees_id_users",
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

    employee = relationship(
        'Employee',
        backref=backref('user', uselist=False, cascade='all,delete'),
        uselist=False
    )
    resource = relationship(
        'Resource',
        backref=backref('user', uselist=False),
        foreign_keys=[resources_id],
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_username(cls, username):
        return DBSession.query(cls).filter(cls.username == username).first()

    @classmethod
    def by_email(cls, email):
        return DBSession.query(cls).filter(cls.email == email).first()

    def validate_password(self, password):
        return self.password == password
