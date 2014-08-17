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


refund_transaction = Table(
    'refund_transaction',
    Base.metadata,
    Column(
        'refund_id',
        Integer,
        ForeignKey(
            'refund.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_refund_id_refund_transaction',
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
            name='fk_fin_transaction_id_refund_transaction',
        ),
        primary_key=True,
    )
)


class Refund(Base):
    __tablename__ = 'refund'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_refund",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_id_refund",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_item_id = Column(
        Integer,
        ForeignKey(
            'account_item.id',
            name="fk_account_item_id_refund",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    invoice_id = Column(
        Integer,
        ForeignKey(
            'invoice.id',
            name="fk_invoice_id_refund",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'refund',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    invoice = relationship(
        'Invoice',
        backref=backref(
            'refunds',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False,
    )
    transactions = relationship(
        'FinTransaction',
        secondary=refund_transaction,
        backref=backref(
            'refund',
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
