# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class LiabilityItem(Base):
    __tablename__ = 'liability_item'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_liability_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    liability_id = Column(
        Integer,
        ForeignKey(
            'liability.id',
            name="fk_liability_id_liability_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=True,
    )
    touroperator_id = Column(
        Integer,
        ForeignKey(
            'touroperator.id',
            name="fk_touroperator_id_liability_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_liability_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    base_price = Column(
        Numeric(16, 2),
        nullable=True,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_liability_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'liability_item',
            uselist=False,
            cascade="all,delete"
        ),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'liabilities_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'liabilities_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    touroperator = relationship(
        'Touroperator',
        backref=backref(
            'liabilities_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    liability = relationship(
        'Liability',
        backref=backref(
            'liabilities_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
