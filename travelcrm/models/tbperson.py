# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


class TBPerson(Base):
    __tablename__ = '_tbperson'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    temporal_id = Column(
        Integer,
        ForeignKey(
            '_temporal.id',
            name="fk_tbperson_id_temporal_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    first_name = Column(
        String(length=32),
        nullable=False,
    )
    last_name = Column(
        String(length=32),
    )
    second_name = Column(
        String(length=32),
    )
    position_name = Column(
        String(length=64),
    )
    deleted = Column(
        Boolean,
        default=False,
    )
    main_id = Column(
        Integer,
        ForeignKey(
            'bperson.id',
            name="fk_main_id_bperson_id",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
    )
    temporal = relationship(
        'Temporal',
        backref=backref(
            'bpersons',
            uselist=True,
            cascade="all,delete",
            lazy="dynamic",
        ),
        uselist=False,
    )
    main = relationship(
        'BPerson',
        backref=backref(
            'temporals',
            uselist=True,
            cascade="all,delete"
        ),
        uselist=False,
    )

    @hybrid_property
    def name(self):
        return self.last_name + " " + self.first_name

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
