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


outgoing_transactions = Table(
    'outgoing_transactions',
    Base.metadata,
    Column(
        'outgoing_id',
        Integer,
        ForeignKey(
            'outgoing.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_outgoing_id_outgoing_transactions',
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
            name='fk_fin_transaction_id_outgoing_transactions',
        ),
        primary_key=True,
    )
)


class Outgoing(Base):
    __tablename__ = 'outgoing'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_outgoing",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'outgoing',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    transactions = relationship(
        'FinTransaction',
        secondary=outgoing_transactions,
        backref=backref(
            'outgoing',
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
