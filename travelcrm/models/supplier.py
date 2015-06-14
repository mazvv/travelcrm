# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
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
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


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


supplier_contract = Table(
    'supplier_contract',
    Base.metadata,
    Column(
        'supplier_id',
        Integer,
        ForeignKey(
            'supplier.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_supplier_id_supplier_contract',
        ),
        primary_key=True,
    ),
    Column(
        'contract_id',
        Integer,
        ForeignKey(
            'contract.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_contract_id_supplier_contract',
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


supplier_subaccount = Table(
    'supplier_subaccount',
    Base.metadata,
    Column(
        'supplier_id',
        Integer,
        ForeignKey(
            'supplier.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_supplier_id_supplier_subaccount',
        ),
        primary_key=True,
    ),
    Column(
        'subaccount_id',
        Integer,
        ForeignKey(
            'subaccount.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_subaccount_id_supplier_subaccount',
        ),
        primary_key=True,
    ),
)


class Supplier(Base):
    __tablename__ = 'supplier'

    STATUS = (
        ('active', _(u'active')),
        ('unactive', _(u'unactive')),
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
    supplier_type_id = Column(
        Integer,
        ForeignKey(
            'supplier_type.id',
            name="fk_supplier_type_id_supplier",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='active',
        nullable=False,
    )
    descr = Column(
        String(255),
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
    supplier_type = relationship(
        'SupplierType',
        backref=backref(
            'suppliers',
            uselist=True,
        ),
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
    contracts = relationship(
        'Contract',
        secondary=supplier_contract,
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
    subaccounts = relationship(
        'Subaccount',
        secondary=supplier_subaccount,
        backref=backref(
            'supplier',
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

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
