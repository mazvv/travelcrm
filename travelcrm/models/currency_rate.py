# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class CurrencyRate(Base):
    __tablename__ = 'currency_rate'
    __table_args__ = (
        UniqueConstraint(
            'currency_id',
            'date',
            'supplier_id',
            name='unique_idx_currency_rate_currency_id_date',
        ),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_currency_rate",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_currency_rate",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    supplier_id = Column(
        Integer,
        ForeignKey(
            'supplier.id',
            name="fk_supplier_id_currency_rate",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    date = Column(
        Date,
        nullable=False,
    )
    rate = Column(
        Numeric(16, 2),
        nullable=False
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'currency_rate',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    supplier = relationship(
        'Supplier',
        backref=backref(
            'currency_rates',
            uselist=True,
            lazy="dynamic"
        ),
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'currency_rates',
            uselist=True,
            lazy="dynamic"
        ),
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

    @classmethod
    def get_by_currency(cls, currency_id, supplier_id, date=None):
        conditions = [
            cls.currency_id == currency_id, 
            cls.supplier_id == supplier_id
        ]
        if date:
            conditions.append(cls.date == date)
            return DBSession.query(cls).filter(*conditions).first()
        return DBSession.query(cls).filter(*conditions).all()
