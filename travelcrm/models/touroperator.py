# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


touroperator_bperson = Table(
    'touroperator_bperson',
    Base.metadata,
    Column(
        'touroperator_id',
        Integer,
        ForeignKey(
            'touroperator.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'bperson_id',
        Integer,
        ForeignKey(
            'bperson.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


touroperator_licence = Table(
    'touroperator_licence',
    Base.metadata,
    Column(
        'touroperator_id',
        Integer,
        ForeignKey(
            'touroperator.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'licence_id',
        Integer,
        ForeignKey(
            'licence.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


touroperator_bank_detail = Table(
    'touroperator_bank_detail',
    Base.metadata,
    Column(
        'touroperator_id',
        Integer,
        ForeignKey(
            'touroperator.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'bank_detail_id',
        Integer,
        ForeignKey(
            'bank_detail.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


class Touroperator(Base):
    __tablename__ = 'touroperator'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_touroperator",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref('touroperator', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )
    bpersons = relationship(
        'BPerson',
        secondary=touroperator_bperson,
        backref=backref('touroperator', uselist=False),
        cascade="all,delete",
        uselist=True,
    )
    licences = relationship(
        'Licence',
        secondary=touroperator_licence,
        backref=backref('touroperator', uselist=False),
        cascade="all,delete",
        uselist=True,
    )
    banks_details = relationship(
        'BankDetail',
        secondary=touroperator_bank_detail,
        backref=backref('touroperator', uselist=False),
        cascade="all,delete",
        uselist=True,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def by_name(cls, name):
        return DBSession.query(cls).filter(cls.name == name).first()
