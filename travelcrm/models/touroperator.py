# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
    ForeignKey,
    UniqueConstraint,
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
            ondelete='restrict',
            onupdate='cascade',
            name='fk_touroperator_id_touroperator_bperson',
        ),
        primary_key=True,
    ),
    Column(
        'bperson_id',
        Integer,
        ForeignKey(
            'bperson.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_bperson_id_touroperator_bperson',
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
            ondelete='restrict',
            onupdate='cascade',
            name='fk_touroperator_id_touroperator_licence',
        ),
        primary_key=True,
    ),
    Column(
        'licence_id',
        Integer,
        ForeignKey(
            'licence.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_licence_id_touroperator_licence',
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
            ondelete='restrict',
            onupdate='cascade',
            name='fk_touroperator_id_touroperator_bank_detail',
        ),
        primary_key=True,
    ),
    Column(
        'bank_detail_id',
        Integer,
        ForeignKey(
            'bank_detail.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_bank_detail_id_touroperator_bank_detail',
        ),
        primary_key=True,
    )
)


touroperator_commission = Table(
    'touroperator_commission',
    Base.metadata,
    Column(
        'touroperator_id',
        Integer,
        ForeignKey(
            'touroperator.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_touroperator_id_touroperator_commission',
        ),
        primary_key=True,
    ),
    Column(
        'commission_id',
        Integer,
        ForeignKey(
            'commission.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_commission_id_touroperator_commission',
        ),
        primary_key=True,
    ),
)


class Touroperator(Base):
    __tablename__ = 'touroperator'
    __table_args__ = (
        UniqueConstraint(
            'name',
            name='unique_idx_name_touroperator',
        ),
    )

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
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'touroperator',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    bpersons = relationship(
        'BPerson',
        secondary=touroperator_bperson,
        backref=backref(
            'touroperator',
            uselist=False,
        ),
        uselist=True,
    )
    licences = relationship(
        'Licence',
        secondary=touroperator_licence,
        backref=backref(
            'touroperator',
            uselist=False,
        ),
        uselist=True,
    )
    banks_details = relationship(
        'BankDetail',
        secondary=touroperator_bank_detail,
        backref=backref(
            'touroperator',
            uselist=False,
        ),
        uselist=True,
    )
    commissions = relationship(
        'Commission',
        secondary=touroperator_commission,
        backref=backref(
            'touroperator',
            uselist=False,
        ),
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
