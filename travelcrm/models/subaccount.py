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


class Subaccount(Base):
    __tablename__ = 'subaccount'
    __table_args__ = (
        UniqueConstraint(
            'name',
            'account_id',
            name='unique_idx_name_account_id_subaccount',
        ),
    )

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
            name="fk_resource_id_subaccount",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_id = Column(
        Integer(),
        ForeignKey(
            'account.id',
            name='fk_subaccount_account_id',
            onupdate='cascade',
            ondelete='restrict',
        ),
        nullable=False,
    )
    name = Column(
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
            'subaccount',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    account = relationship(
        'Account',
        backref=backref(
            'subaccounts',
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
