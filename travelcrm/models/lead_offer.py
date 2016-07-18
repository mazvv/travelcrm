# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


class LeadOffer(Base):
    __tablename__ = 'lead_offer'

    STATUS = (
        ('awaiting', _(u'awaiting')),
        ('success', _(u'success')),
        ('failure', _(u'failure')),
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
            name="fk_resource_id_lead_offer",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    lead_id = Column(
        Integer,
        ForeignKey(
            'lead.id',
            name="fk_lead_id_lead_offer",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_lead_offer",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_lead_offer",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    supplier_id = Column(
        Integer,
        ForeignKey(
            'supplier.id',
            name="fk_supplier_id_lead_offer",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='awaiting',
        nullable=False,
    )
    descr = Column(
        String,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'lead_offer',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    lead = relationship(
        'Lead',
        backref=backref(
            'leads_offers',
            lazy='dynamic',
            uselist=True,
        ),
        cascade="all,delete",
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'leads_offers',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'leads_offers',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    supplier = relationship(
        'Supplier',
        backref=backref(
            'leads_offers',
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

    @classmethod
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )
