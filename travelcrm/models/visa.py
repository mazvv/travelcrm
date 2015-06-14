# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    String,
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


visa_order_item = Table(
    'visa_order_item',
    Base.metadata,
    Column(
        'order_item_id',
        Integer,
        ForeignKey(
            'order_item.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_order_item_id_visa_order_item',
        ),
        primary_key=True,
    ),
    Column(
        'visa_id',
        Integer,
        ForeignKey(
            'visa.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_visa_id_visa_order_item',
        ),
        primary_key=True,
    ),
)


class Visa(Base):
    __tablename__ = 'visa'

    TYPE = (
        ('single', _(u'single')),
        ('dual', _(u'dual')),
        ('multi', _(u'multi')),
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
            name="fk_resource_id_visa",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    country_id = Column(
        Integer,
        ForeignKey(
            'country.id',
            name="fk_country_id_visa",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    start_date = Column(
        Date,
        nullable=False,
    )
    end_date = Column(
        Date,
    )
    type = Column(
        EnumIntType(TYPE),
        default='single',
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'visa',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    country = relationship(
        'Country',
        backref=backref(
            'visas',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    order_item = relationship(
        'OrderItem',
        secondary=visa_order_item,
        backref=backref(
            'visa',
            uselist=False,
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
