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
    Base,
    DBSession
)


class CompanyStruct(Base):
    __tablename__ = '_companies_structures'

    rid = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_companies_structures",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    _companies_rid = Column(
        Integer,
        ForeignKey(
            '_companies.rid',
            name="fk_companies_rid_companies_structures",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    _companies_structures_rid = Column(
        Integer(),
        ForeignKey(
            '_companies_structures.rid',
            name='fk_companies_structures_companies_structures_rid',
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
            cascade="all,delete"
        ),
        uselist=False
    )

    children = relationship(
        'CompanyStruct',
        backref=backref(
            'parent',
            remote_side=[rid]
        ),
        uselist=True,
        lazy='dynamic',
        cascade="all,delete"
    )

    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @classmethod
    def condition_root_level(cls):
        return cls._companies_structures_rid == None

    @classmethod
    def condition_parent_rid(cls, _companies_structures_rid):
        return cls._companies_structures_rid == _companies_structures_rid

    @classmethod
    def condition_company_rid(cls, _companies_rid):
        return cls._companies_rid == _companies_rid
