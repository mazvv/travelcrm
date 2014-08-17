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


income_transaction = Table(
    'income_transaction',
    Base.metadata,
    Column(
        'income_id',
        Integer,
        ForeignKey(
            'income.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_income_id_income_transaction',
        ),
        primary_key=True,
    ),
    Column(
        'fin_transaction_id',
        Integer,
        ForeignKey(
            'fin_transaction.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_fin_transaction_id_income_transaction',
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
    transactions = relationship(
        'FinTransaction',
        secondary=income_transaction,
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

    @property
    def sum(self):
        return sum(transaction.sum for transaction in self.transactions)

    @property
    def date(self):
        assert self.transactions
        return self.transactions[0].date
