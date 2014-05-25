# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Invoice(Base):
    __tablename__ = 'invoice'

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
            name="fk_resource_id_invoice",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    bank_detail_id = Column(
        Integer,
        ForeignKey(
            'bank_detail.id',
            name="fk_bank_detail_id_invoice",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    invoice_resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_invoice_resource_id_invoice",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'invoice',
            uselist=False,
            cascade="all,delete"
        ),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False,
    )
    invoice_resource = relationship(
        'Resource',
        backref=backref(
            'invoices',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[invoice_resource_id],
        uselist=False,
    )
    bank_detail = relationship(
        'BankDetail',
        backref=backref(
            'invoices',
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
