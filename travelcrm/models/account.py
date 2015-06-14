# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


class Account(Base):
    __tablename__ = 'account'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_account',
        ),
    )

    ACCOUNTS_TYPES = (
        ('bank', _(u'bank')),
        ('cash', _(u'cash'))
    )
    STATUS = (
        ('active', _(u'active')),
        ('disabled', _(u'disabled')),
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
            name="fk_resource_id_account",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_account",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_type = Column(
        EnumIntType(ACCOUNTS_TYPES),
        nullable=False,
    )
    name = Column(
        String(length=255),
        nullable=False,
    )
    display_text = Column(
        String(length=255),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='active',
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'account',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'accounts',
            uselist=True,
            lazy='dynamic',
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
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
