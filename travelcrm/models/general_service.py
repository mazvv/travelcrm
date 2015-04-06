# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class GeneralService(Base):
    __tablename__ = 'general_service'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_general_service",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    order_item_id = Column(
        Integer,
        ForeignKey(
            'order_item.id',
            name="fk_order_item_id_general_service",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'general_service',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    order_item = relationship(
        'OrderItem',
        backref=backref(
            'general_services',
            uselist=True,
            lazy='dynamic'
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
