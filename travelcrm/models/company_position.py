# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey
    )
from sqlalchemy.orm import (
    relationship,
    backref
)

from ..models import (
    DBSession,
    Base
)


class CompanyPosition(Base):
    __tablename__ = 'companies_positions'

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_companies_positions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    structure_id = Column(
        Integer(),
        ForeignKey(
            'companies_structures.id',
            name='fk_companies_positions_structure_id',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    name = Column(
        String(length=32),
        nullable=False
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'company_position', uselist=False, cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )

    company_struct = relationship(
        'CompanyStruct',
        backref=backref(
            'companies_positions', uselist=True, cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_structure_id(cls, structure_id):
        return cls.structure_id == structure_id
