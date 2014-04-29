# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    Numeric,
    ForeignKey,
    Table,
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
        'tour_id',
        Integer,
        ForeignKey(
            'tour.id',
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


class Tour(Base):
    __tablename__ = 'tour'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    deal_date = Column(
        Date,
        nullable=False,
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_tour",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    touroperator_id = Column(
        Integer,
        ForeignKey(
            'touroperator.id',
            name="fk_touroperator_id_tour_point",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    customer_id = Column(
        Integer,
        ForeignKey(
            'person.id',
            name="fk_customer_id_tour",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    advsource_id = Column(
        Integer,
        ForeignKey(
            'advsource.id',
            name="fk_advsource_id_tour",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    price = Column(
        Numeric(16, 2),
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
    adults = Column(
        Integer,
        nullable=False,
    )
    children = Column(
        Integer,
        nullable=False,
    )
    start_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_start_location_id_tour",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    end_location_id = Column(
        Integer,
        ForeignKey(
            'location.id',
            name="fk_end_location_id_tour",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    start_date = Column(
        Date,
        nullable=False,
    )
    end_date = Column(
        Date,
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref('tour', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )
    customer = relationship(
        'Person',
        backref=backref(
            'customers_tours',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=True,
    )
    touroperator = relationship(
        'Touroperator',
        backref=backref(
            'tours',
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
            'tours',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=False,
    )
    advsource = relationship(
        'Advsource',
        backref=backref(
            'tours',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        cascade="all,delete",
        uselist=False,
    )
    start_location = relationship(
        'Location',
        backref=backref(
            'tours_starts',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        foreign_keys=[start_location_id],
        cascade="all,delete",
        uselist=False,
    )
    end_location = relationship(
        'Location',
        backref=backref(
            'tours_ends',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic"
        ),
        foreign_keys=[end_location_id],
        cascade="all,delete",
        uselist=False,
    )
    persons = relationship(
        'Person',
        secondary=tour_person,
        backref=backref(
            'tours',
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
