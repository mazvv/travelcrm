# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class PositionPermision(Base):
    __tablename__ = 'positions_permisions'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resources_types_id = Column(
        Integer,
        ForeignKey(
            'resources_types.id',
            name="fk_resources_type_id_positions_permissions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    companies_positions_id = Column(
        Integer,
        ForeignKey(
            'companies_positions.id',
            name="fk_companies_positions_id_positions_permisions",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    permisions = Column(
        ARRAY(String),
    )
    scope_type = Column(
        String
    )
    companies_structures_id = Column(
        Integer,
        ForeignKey(
            'companies_structures.id',
            name='fk_positions_permisions_companies_structures_id',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )

    company_position = relationship(
        'CompanyPosition',
        backref=backref(
            'permisions',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False
    )

    resource_type = relationship(
        'ResourceType',
        backref=backref(
            'resource_type_permisions',
            uselist=True,
            lazy='dynamic',
            cascade="all,delete"
        ),
        uselist=False
    )

    company_struct = relationship(
        'CompanyStruct',
        backref=backref(
            'positions_permisions',
            uselist=True,
            lazy='dynamic',
            cascade="all,delete"
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_company_position_id(cls, company_position_id):
        return cls.companies_positions_id == company_position_id

    @classmethod
    def condition_resource_type_id(cls, resource_type_id):
        return cls.resources_types_id == resource_type_id
