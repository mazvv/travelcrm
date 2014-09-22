# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


outgoing_transaction = Table(
    'outgoing_transaction',
    Base.metadata,
    Column(
        'outgoing_id',
        Integer,
        ForeignKey(
            'outgoing.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_outgoing_id_outgoing_transaction',
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
            name='fk_fin_transaction_id_outgoing_transaction',
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
    account_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_id_outgoing",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    touroperator_id = Column(
        Integer,
        ForeignKey(
            'touroperator.id',
            name="fk_trouroperator_id_outgoing",
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
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    account = relationship(
        'Account',
        backref=backref(
            'outgoings',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    touroperator = relationship(
        'Touroperator',
        backref=backref(
            'outgoings',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
