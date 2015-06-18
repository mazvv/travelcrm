# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
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


contract_commission = Table(
    'contract_commission',
    Base.metadata,
    Column(
        'contract_id',
        Integer,
        ForeignKey(
            'contract.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_contract_id_contract_commission',
        ),
        primary_key=True,
    ),
    Column(
        'commission_id',
        Integer,
        ForeignKey(
            'commission.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_commission_id_contract_commission',
        ),
        primary_key=True,
    ),
)


class Contract(Base):
    __tablename__ = 'contract'

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
            name="fk_resource_id_contract",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    num = Column(
        String,
        nullable=False,
    )
    date = Column(
        Date,
        nullable=False
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
            'contract',
            uselist=False,
            cascade="all,delete",
        ),
        cascade="all,delete",
        uselist=False,
    )
    commissions = relationship(
        'Commission',
        secondary=contract_commission,
        backref=backref(
            'contract',
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
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    @classmethod
    def condition_active(cls):
        return cls.status == 'active'
