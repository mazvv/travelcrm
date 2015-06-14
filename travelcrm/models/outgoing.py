# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


outgoing_cashflow = Table(
    'outgoing_cashflow',
    Base.metadata,
    Column(
        'outgoing_id',
        Integer,
        ForeignKey(
            'outgoing.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_outgoing_id_outgoing_cashflow',
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
            name='fk_cashflow_id_outgoing_cashflow',
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
    date = Column(
        Date,
        nullable=False,
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
    account_item_id = Column(
        Integer,
        ForeignKey(
            'account_item.id',
            name="fk_account_item_id_outgoing",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    subaccount_id = Column(
        Integer,
        ForeignKey(
            'subaccount.id',
            name="fk_subaccount_id_outgoing",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    sum = Column(
        Numeric(16, 2),
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'outgoing',
            uselist=False,
            cascade="all,delete"
        ),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    account_item = relationship(
        'AccountItem',
        backref=backref(
            'outgoings',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    subaccount = relationship(
        'Subaccount',
        backref=backref(
            'outgoings',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    cashflows = relationship(
        'Cashflow',
        secondary=outgoing_cashflow,
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
