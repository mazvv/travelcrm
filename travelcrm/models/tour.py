# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    DateTime,
    Numeric,
    ForeignKey,
    )
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Tour(Base):
    __tablename__ = 'tour'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
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
    price = Column(
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
    start_dt = Column(
        DateTime,
        nullable=False,
    )
    end_dt = Column(
        DateTime,
        nullable=False,
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

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
