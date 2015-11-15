# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class BankDetail(Base):
    __tablename__ = 'bank_detail'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_bank_detail",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_bank_detail",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    bank_id = Column(
        Integer,
        ForeignKey(
            'bank.id',
            name="fk_bank_id_bank_detail",
            ondelete='cascade',
            onupdate='cascade',
        ),
        nullable=False,
    )
    beneficiary = Column(
        String(length=255),
    )
    account = Column(
        String(length=32),
        nullable=False,
    )
    swift_code = Column(
        String(length=32),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'bank_detail',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'banks_details',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    bank = relationship(
        'Bank',
        backref=backref(
            'banks_details',
            uselist=True,
            lazy="dynamic",
            cascade='all, delete-orphan'
        ),
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
