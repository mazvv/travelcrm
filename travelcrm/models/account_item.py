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


class AccountItem(Base):
    __tablename__ = 'account_item'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_account_item',
        ),
    )

    ITEM_TYPES = [
        ('income', _(u'income')),
        ('expense', _(u'expense')),
    ]

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_account_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=128),
        nullable=False,
    )
    item_type = Column(
        EnumIntType(ITEM_TYPES),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'account_item',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
