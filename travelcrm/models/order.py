# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
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


class Order(Base):
    __tablename__ = 'order'

    STATUS = (
        ('new', _(u'new')),
        ('in_work', _(u'in work')),
        ('failure', _(u'failure')),
        ('success', _(u'success')),
    )

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    deal_date = Column(
        Date,
        nullable=False,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    lead_id = Column(
        Integer,
        ForeignKey(
            'lead.id',
            name="fk_lead_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    advsource_id = Column(
        Integer,
        ForeignKey(
            'advsource.id',
            name="fk_advsource_id_order",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='awaiting',
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'order',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    lead = relationship(
        'Lead',
        backref=backref(
            'order',
            uselist=False,
        ),
        uselist=False,
    )
    customer = relationship(
        'Person',
        backref=backref(
            'orders',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    advsource = relationship(
        'Advsource',
        backref=backref(
            'orders',
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

    @classmethod
    def condition_status_success(cls):
        return cls.status == 'success'
