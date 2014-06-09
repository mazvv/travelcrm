# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class FinTransaction(Base):
    __tablename__ = 'fin_transaction'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    account_item_id = Column(
        Integer,
        ForeignKey(
            'account_item.id',
            name="fk_account_item_id_fin_transaction",
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

    account_item = relationship(
        'AccountItem',
        backref=backref(
            'transactions',
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
