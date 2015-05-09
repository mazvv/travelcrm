# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    String,
    ForeignKey,
    CheckConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


class Commission(Base):
    __tablename__ = 'commission'
    __table_args__ = (
        CheckConstraint(
            'percentage between 0 and 100',
            name='chk_commission_percentage'
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
            name="fk_resource_id_commission",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_commission",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    percentage = Column(
        Numeric(5, 2),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_commission",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    descr = Column(
        String(255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'commission',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'commissions',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'commissions',
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

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )
