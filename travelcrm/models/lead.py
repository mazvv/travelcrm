# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


lead_wish = Table(
    'lead_wish',
    Base.metadata,
    Column(
        'lead_id',
        Integer,
        ForeignKey(
            'lead.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_lead_id_lead_wish',
        ),
        primary_key=True,
    ),
    Column(
        'wish_id',
        Integer,
        ForeignKey(
            'wish.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_wish_id_lead_wish',
        ),
        primary_key=True,
    ),
)


lead_offer = Table(
    'lead_offer',
    Base.metadata,
    Column(
        'lead_id',
        Integer,
        ForeignKey(
            'lead.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_lead_id_lead_offer',
        ),
        primary_key=True,
    ),
    Column(
        'offer_id',
        Integer,
        ForeignKey(
            'offer.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_offer_item_id_lead_offer',
        ),
        primary_key=True,
    ),
)


class Lead(Base):
    __tablename__ = 'lead'

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
    lead_date = Column(
        Date,
        nullable=False,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_lead",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    advsource_id = Column(
        Integer,
        ForeignKey(
            'advsource.id',
            name="fk_advsource_id_lead",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_lead",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='new',
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'lead',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    wishes = relationship(
        'Wish',
        secondary=lead_wish,
        backref=backref(
            'lead',
            uselist=False,
        ),
        uselist=True,
        lazy="dynamic",
    )
    offers = relationship(
        'Offer',
        secondary=lead_offer,
        backref=backref(
            'lead',
            uselist=False,
        ),
        uselist=True,
        lazy="dynamic",
    )
    customer = relationship(
        'Person',
        backref=backref(
            'customers_leads',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    advsource = relationship(
        'Advsource',
        backref=backref(
            'leads',
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
