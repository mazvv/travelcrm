# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class User(Base):
    __tablename__ = 'user'
    __table_args__ = (
        UniqueConstraint(
            'email',
            name='unique_idx_users_email',
        ),
        UniqueConstraint(
            'username',
            name='unique_idx_users_username',
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
            name="fk_resource_id_user",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    employee_id = Column(
        Integer,
        ForeignKey(
            'employee.id',
            name="fk_employee_id_user",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    username = Column(
        String(length=32),
        nullable=False,
    )
    email = Column(
        String(length=128),
        nullable=False,
    )
    password = Column(
        String(length=128),
        nullable=False
    )

    employee = relationship(
        'Employee',
        backref=backref(
            'user',
            uselist=False,
            cascade='all,delete'
        ),
        uselist=False
    )
    resource = relationship(
        'Resource',
        backref=backref('user', uselist=False),
        uselist=False
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
    def by_username(cls, username):
        return DBSession.query(cls).filter(cls.username == username).first()

    @classmethod
    def by_email(cls, email):
        return DBSession.query(cls).filter(cls.email == email).first()

    @classmethod
    def by_employee_id(cls, employee_id):
        return (
            DBSession.query(cls)
            .filter(cls.employee_id == employee_id)
            .first()
        )

    def validate_password(self, password):
        return self.password == password
