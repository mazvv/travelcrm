# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    CheckConstraint,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Posting(Base):
    __tablename__ = 'posting'
    __table_args__ = (
        CheckConstraint(
            'account_from_id is not null or account_to_id is not null',
            name='constraint_at_list_single_account_not_null',
        ),
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
            name="fk_resource_id_posting",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    account_from_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_from_id_posting",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    account_to_id = Column(
        Integer,
        ForeignKey(
            'account.id',
            name="fk_account_to_id_posting",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    account_item_id = Column(
        Integer,
        ForeignKey(
            'account_item.id',
            name="fk_account_item_id_posting",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    sum = Column(
        Numeric(16, 2),
        nullable=False,
    )
    date = Column(
        Date(),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'posting',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )
    account_from = relationship(
        'Account',
        backref=backref(
            'postings_from',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[account_from_id],
        uselist=False
    )
    account_to = relationship(
        'Account',
        backref=backref(
            'postings_to',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[account_to_id],
        uselist=False
    )
    account_item = relationship(
        'AccountItem',
        backref=backref(
            'postings',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    def __repr__(self):
        return "%s_%s: %s" % (self.__class__.__name__, self.id, self.sum)
