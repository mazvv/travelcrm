# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    String,
    Boolean,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


spassport_order_item = Table(
    'spassport_order_item',
    Base.metadata,
    Column(
        'order_item_id',
        Integer,
        ForeignKey(
            'order_item.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_order_item_id_spassport_order_item',
        ),
        primary_key=True,
    ),
    Column(
        'spassport_id',
        Integer,
        ForeignKey(
            'spassport.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_spassport_id_spassport_order_item',
        ),
        primary_key=True,
    ),
)


class Spassport(Base):
    __tablename__ = 'spassport'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_spassport",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    photo_done = Column(
        Boolean,
        default=False,
        nullable=False,
    )
    docs_receive_date = Column(
        Date,
    )
    docs_transfer_date = Column(
        Date,
    )
    passport_receive_date = Column(
        Date,
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'spassport',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    order_item = relationship(
        'OrderItem',
        secondary=spassport_order_item,
        backref=backref(
            'spassport',
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
