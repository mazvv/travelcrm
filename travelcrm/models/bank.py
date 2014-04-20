# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    Table,
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
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'address_id',
        Integer,
        ForeignKey(
            'address.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


class Bank(Base):
    __tablename__ = 'bank'

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
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=255),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref('bank', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )
    addresses = relationship(
        'Address',
        secondary=bank_address,
        backref=backref('bank', uselist=False),
        cascade="all,delete",
        uselist=True,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
