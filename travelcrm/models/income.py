# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


income_transfer = Table(
    'income_transfer',
    Base.metadata,
    Column(
        'income_id',
        Integer,
        ForeignKey(
            'income.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_income_id_income_transfer',
        ),
        primary_key=True,
    ),
    Column(
        'transfer_id',
        Integer,
        ForeignKey(
            'transfer.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_transfer_id_income_transfer',
        ),
        primary_key=True,
    )
)


class Income(Base):
    __tablename__ = 'income'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_income",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    invoice_id = Column(
        Integer,
        ForeignKey(
            'invoice.id',
            name="fk_invoice_id_income",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'income',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    invoice = relationship(
        'Invoice',
        backref=backref(
            'incomes',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    transfers = relationship(
        'Transfer',
        secondary=income_transfer,
        backref=backref(
            'income',
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
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @property
    def sum(self):
        return sum(
            transfer.sum 
            for transfer in self.transfers 
            if transfer.account_from_id == None 
            and transfer.subaccount_from_id == None
        )

    @property
    def date(self):
        assert self.transfers
        return self.transfers[0].date

    def rollback(self):
        for transfer in self.transfers:
            DBSession.delete(transfer)
        DBSession.flush(self.transfers)
