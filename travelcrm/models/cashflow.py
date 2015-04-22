# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    CheckConstraint,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Cashflow(Base):
    __tablename__ = 'cashflow'
    __table_args__ = (
        CheckConstraint(
            'not (account_from_id is not null '
            'and subaccount_from_id is not null) and '
            'not (account_to_id is not null '
            'and subaccount_to_id is not null)',
            name='constraint_cashflow_account_subaccount',
        ),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    account_from_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_from_id_cashflow",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    subaccount_from_id = Column(
        Integer,
        ForeignKey(
            'subaccount.id',
            name="fk_subaccount_from_id_cashflow",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    account_to_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_to_id_cashflow",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    subaccount_to_id = Column(
        Integer,
        ForeignKey(
            'subaccount.id',
            name="fk_subaccount_to_id_cashflow",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    account_item_id = Column(
        Integer,
        ForeignKey(
            'account_item.id',
            name="fk_account_item_id_cashflow",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    sum = Column(
        Numeric(16, 2),
        nullable=False,
    )
    date = Column(
        Date(),
        nullable=False,
    )
    account_from = relationship(
        'Account',
        backref=backref(
            'cashflows_from',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[account_from_id],
        uselist=False
    )
    subaccount_from = relationship(
        'Subaccount',
        backref=backref(
            'cashflows_from',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[subaccount_from_id],
        uselist=False
    )
    account_to = relationship(
        'Account',
        backref=backref(
            'cashflows_to',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[account_to_id],
        uselist=False
    )
    subaccount_to = relationship(
        'Subaccount',
        backref=backref(
            'cashflows_to',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[subaccount_to_id],
        uselist=False
    )
    account_item = relationship(
        'AccountItem',
        backref=backref(
            'cashflows',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @property
    def currency(self):
        if self.account_from:
            return self.account_from.currency
        if self.account_to:
            return self.account_to.currency
        if self.subaccount_from:
            return self.subaccount_from.account.currency
        if self.subaccount_to:
            return self.subaccount_to.account.currency
        
    def __repr__(self):
        return "%s_%s: %s" % (self.__class__.__name__, self.id, self.sum)
