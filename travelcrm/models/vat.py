# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Date,
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


class Vat(Base):
    __tablename__ = 'vat'

    CALC_METHOD = (
        ('commission', _(u'commission')),
        ('full', _(u'full')),
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
            name="fk_resource_id_vat",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_id_vat",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_vat",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    date = Column(
        Date,
        nullable=False,
    )
    vat = Column(
        Numeric(5, 2),
        nullable=False,
    )
    calc_method = Column(
        EnumIntType(CALC_METHOD),
        default='commission',
        nullable=False,
    )
    descr = Column(
        String(255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'vat',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    account = relationship(
        'Account',
        backref=backref(
            'vats',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'vats',
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

    def is_commission(self):
        return self.calc_method == 'commission'

    def is_full(self):
        return self.calc_method == 'full'
