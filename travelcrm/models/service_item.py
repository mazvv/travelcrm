# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Numeric,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class ServiceItem(Base):
    __tablename__ = 'service_item'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_service_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    service_id = Column(
        Integer,
        ForeignKey(
            'service.id',
            name="fk_service_id_service_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_service_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    touroperator_id = Column(
        Integer,
        ForeignKey(
            'touroperator.id',
            name="fk_touroperator_id_service_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    person_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_person_id_service_item",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
        nullable=False,
    )
    base_price = Column(
        Numeric(16, 2),
        default=0,
        nullable=False
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'service_item',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    service = relationship(
        'Service',
        backref=backref(
            'services_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'services_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    touroperator = relationship(
        'Touroperator',
        backref=backref(
            'services_items',
            lazy='dynamic',
            uselist=True,
        ),
        uselist=False,
    )
    person = relationship(
        'Person',
        backref=backref(
            'services_items',
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
