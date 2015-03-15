# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


bank_address = Table(
    'bank_address',
    Base.metadata,
    Column(
        'bank_id',
        Integer,
        ForeignKey(
            'bank.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_bank_id_bank_address',
        ),
        primary_key=True,
    ),
    Column(
        'address_id',
        Integer,
        ForeignKey(
            'address.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_address_id_bank_address',
        ),
        primary_key=True,
    )
)


class Bank(Base):
    __tablename__ = 'bank'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_bank',
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
            name="fk_resource_id_bank",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=255),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'bank',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    addresses = relationship(
        'Address',
        secondary=bank_address,
        backref=backref(
            'bank',
            uselist=False,
        ),
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

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
