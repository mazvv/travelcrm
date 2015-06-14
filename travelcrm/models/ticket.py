# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    DateTime,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base,
)


ticket_order_item = Table(
    'ticket_order_item',
    Base.metadata,
    Column(
        'order_item_id',
        Integer,
        ForeignKey(
            'order_item.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_order_item_id_ticket_order_item',
        ),
        primary_key=True,
    ),
    Column(
        'ticket_id',
        Integer,
        ForeignKey(
            'ticket.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_ticket_id_ticket_order_item',
        ),
        primary_key=True,
    ),
)


class Ticket(Base):
    __tablename__ = 'ticket'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_ticket",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    start_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_start_location_id_ticket",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    end_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_end_location_id_ticket",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    ticket_class_id = Column(
        Integer,
        ForeignKey(
            'ticket_class.id',
            name="fk_ticket_class_id_ticket",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    transport_id = Column(
        Integer,
        ForeignKey(
            'transport.id',
            name="fk_transport_id_ticket",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    start_dt = Column(
        DateTime(timezone=True),
        nullable=False,
    )
    start_additional_info = Column(
        String(length=128),
    )
    end_dt = Column(
        DateTime(timezone=True),
        nullable=False,
    )
    end_additional_info = Column(
        String(length=128),
    )
    adults = Column(
        Integer,
        nullable=False,
    )
    children = Column(
        Integer,
        nullable=False,
    )
    descr = Column(
        String(length=255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'ticket',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    ticket_class = relationship(
        'TicketClass',
        backref=backref(
            'tickets',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    transport = relationship(
        'Transport',
        backref=backref(
            'tickets',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False,
    )
    start_location = relationship(
        'Location',
        backref=backref(
            'tickets_starts',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[start_location_id],
        uselist=False,
    )
    end_location = relationship(
        'Location',
        backref=backref(
            'tickets_ends',
            uselist=True,
            lazy="dynamic"
        ),
        foreign_keys=[end_location_id],
        uselist=False,
    )
    order_item = relationship(
        'OrderItem',
        secondary=ticket_order_item,
        backref=backref(
            'ticket',
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
