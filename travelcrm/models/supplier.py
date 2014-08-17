# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


supplier_bperson = Table(
    'supplier_bperson',
    Base.metadata,
    Column(
        'supplier_id',
        Integer,
        ForeignKey(
            'supplier.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_supplier_id_supplier_bperson',
        ),
        primary_key=True,
    ),
    Column(
        'bperson_id',
        Integer,
        ForeignKey(
            'bperson.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_bperson_id_supplier_bperson',
        ),
        primary_key=True,
    )
)

supplier_bank_detail = Table(
    'supplier_bank_detail',
    Base.metadata,
    Column(
        'supplier_id',
        Integer,
        ForeignKey(
            'supplier.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_supplier_id_supplier_bank_detail',
        ),
        primary_key=True,
    ),
    Column(
        'bank_detail_id',
        Integer,
        ForeignKey(
            'bank_detail.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_bank_detail_id_supplier_bank_detail',
        ),
        primary_key=True,
    )
)


class Supplier(Base):
    __tablename__ = 'supplier'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_supplier',
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
            name="fk_resource_id_supplier",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=64),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'supplier',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    bpersons = relationship(
        'BPerson',
        secondary=supplier_bperson,
        backref=backref(
            'supplier',
            uselist=False,
        ),
        uselist=True,
    )
    banks_details = relationship(
        'BankDetail',
        secondary=supplier_bank_detail,
        backref=backref(
            'supplier',
            uselist=False,
        ),
        uselist=True,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
