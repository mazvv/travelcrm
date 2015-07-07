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
from sqlalchemy.dialects.postgresql import JSON

from ..models import (
    DBSession,
    Base
)


company_subaccount = Table(
    'company_subaccount',
    Base.metadata,
    Column(
        'company_id',
        Integer,
        ForeignKey(
            'company.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_company_id_company_subaccount',
        ),
        primary_key=True,
    ),
    Column(
        'subaccount_id',
        Integer,
        ForeignKey(
            'subaccount.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_subaccount_id_company_subaccount',
        ),
        primary_key=True,
    ),
)


class Company(Base):
    __tablename__ = 'company'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_company',
        ),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )

    # can be nullable on creation
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_company",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_company",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    email = Column(
        String(length=32),
        nullable=False,
    )
    settings = Column(
        JSON,
        primary_key=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'company',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'companies',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    subaccounts = relationship(
        'Subaccount',
        secondary=company_subaccount,
        backref=backref(
            'company',
            uselist=False,
        ),
        cascade="all,delete",
        uselist=True,
    )
    

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_resource_id(cls, resource_id):
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
