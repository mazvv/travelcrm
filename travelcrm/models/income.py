# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Date,
    Numeric,
    Integer,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


income_cashflow = Table(
    'income_cashflow',
    Base.metadata,
    Column(
        'income_id',
        Integer,
        ForeignKey(
            'income.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_income_id_income_cashflow',
        ),
        primary_key=True,
    ),
    Column(
        'cashflow_id',
        Integer,
        ForeignKey(
            'cashflow.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_cashflow_id_income_cashflow',
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
    descr = Column(
        String(length=255),
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
    account_item = relationship(
        'AccountItem',
        backref=backref(
            'incomes',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    cashflows = relationship(
        'Cashflow',
        secondary=income_cashflow,
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

    def rollback(self):
        cashflows = list(self.cashflows)
        self.cashflows = []
        DBSession.flush()

        for cashflow in cashflows:
            DBSession.delete(cashflow)
        DBSession.flush()
