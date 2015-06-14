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
    TYPE = (
        ('any', _(u'any')),
        ('revenue', _(u'revenue')),
        ('expenses', _(u'expenses')),
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
            name="fk_resource_id_account_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'account_item.id',
            name='fk_account_item_parent_id',
            onupdate='cascade',
            ondelete='restrict',
        )
    )
    name = Column(
        String(length=128),
        nullable=False,
    )
    type = Column(
        EnumIntType(TYPE),
        default='revenue',
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='active',
        nullable=False,
    )
    descr = Column(
        String(128),
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
    children = relationship(
        'AccountItem',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        lazy='dynamic',
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

    @classmethod
    def condition_root_level(cls):
        return cls.parent_id == None

    @classmethod
    def condition_parent_id(cls, parent_id):
        return cls.parent_id == parent_id

    def get_all_descendants(self):
        all_accounts_items = DBSession.query(AccountItem)
        accounts_items = {}

        for item in all_accounts_items:
            item_children = accounts_items.setdefault(item.parent_id, [])
            item_children.append(item)
            accounts_items[item.parent_id] = item_children

        def recurse_accumulate(item, result):
            if accounts_items.get(item.id):
                for item in accounts_items.get(item.id):
                    result.append(item)
                    recurse_accumulate(item, result)
            return result

        if accounts_items.get(self.id):
            result = []
            return recurse_accumulate(self, result)

    def is_type_any(self):
        return self.type == 'any'

    def is_type_revenue(self):
        return self.type == 'revenue'

    def is_type_expenses(self):
        return self.type == 'expenses'
