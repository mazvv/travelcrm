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


class CompanyStruct(Base):
    __tablename__ = 'companies_structures'

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resources_id = Column(
        Integer,
        ForeignKey(
            'resources.id',
            name="fk_resources_id_companies_structures",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    companies_id = Column(
        Integer,
        ForeignKey(
            'companies.id',
            name="fk_companies_id_companies_structures",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'companies_structures.id',
            name='fk_companies_structures_parent_id',
            onupdate='cascade',
            ondelete='cascade',
            use_alter=True,
        )
    )
    name = Column(
        String(length=32),
        nullable=False
    )

    resource = relationship(
        'Resource',
        backref=backref('company_struct', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False
    )

    company = relationship(
        'Company',
        backref=backref(
            'company_structs',
            uselist=True,
            lazy='dynamic',
        ),
        uselist=False
    )

    children = relationship(
        'CompanyStruct',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        lazy='dynamic',
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    @classmethod
    def condition_root_level(cls):
        return cls.parent_id == None

    @classmethod
    def condition_parent_id(cls, parent_id):
        return cls.parent_id == parent_id

    @classmethod
    def condition_company_id(cls, companies_id):
        return cls.companies_id == companies_id
