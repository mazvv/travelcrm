# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    Boolean,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class TLicence(Base):
    __tablename__ = '_tlicence'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    temporal_id = Column(
        Integer,
        ForeignKey(
            '_temporal.id',
            name="fk_tlicence_id_temporal_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    licence_num = Column(
        String,
        nullable=False,
    )
    date_from = Column(
        Date,
        nullable=False
    )
    date_to = Column(
        Date,
        nullable=False
    )
    deleted = Column(
        Boolean,
        default=False,
    )
    main_id = Column(
        Integer,
        ForeignKey(
            'licence.id',
            name="fk_main_id_licence_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    temporal = relationship(
        'Temporal',
        backref=backref(
            'licences',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic",
        ),
        uselist=False,
    )
    main = relationship(
        'Licence',
        backref=backref(
            'temporals',
            uselist=True,
            cascade="all,delete"
        ),
        uselist=False,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
