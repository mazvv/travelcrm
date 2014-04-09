# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


tour_person = Table(
    'tour_person',
    Base.metadata,
    Column(
        'tour_deal_id',
        Integer,
        ForeignKey(
            'tour_deal.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'person_id',
        Integer,
        ForeignKey(
            'person.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
)


class TourDeal(Base):
    __tablename__ = 'tour_deal'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_tour_deal",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    deal_date = Column(
        Date,
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_tour_deal",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    tour_id = Column(
        Integer,
        ForeignKey(
            'tour.id',
            name="fk_tour_id_tour_deal",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    sum = Column(
        Numeric(16, 4),
        nullable=False
    )
    currency_id = Column(
        Integer,
        ForeignKey(
            'currency.id',
            name="fk_currency_id_tour",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref('tour_deal', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )
    customer = relationship(
        'Person',
        backref=backref(
            'tours_customer',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=True,
    )
    tour = relationship(
        'Tour',
        backref=backref(
            'tours_deals',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=False,
    )
    currency = relationship(
        'Currency',
        backref=backref(
            'tours_deals',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=False,
    )
    persons = relationship(
        'Person',
        secondary=tour_person,
        backref=backref(
            'tours_deals',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=True,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
