# -*-coding: utf-8 -*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
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


structure_contact = Table(
    'structure_contact',
    Base.metadata,
    Column(
        'structure_id',
        Integer,
        ForeignKey(
            'structure.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'contact_id',
        Integer,
        ForeignKey(
            'contact.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


structure_bank_detail = Table(
    'structure_bank_detail',
    Base.metadata,
    Column(
        'structure_id',
        Integer,
        ForeignKey(
            'structure.id',
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


structure_address = Table(
    'structure_address',
    Base.metadata,
    Column(
        'structure_id',
        Integer,
        ForeignKey(
            'structure.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    ),
    Column(
        'address_id',
        Integer,
        ForeignKey(
            'address.id',
            ondelete='cascade',
            onupdate='cascade'
        ),
        primary_key=True,
    )
)


class Structure(Base):
    __tablename__ = 'structure'

    id = Column(
        Integer,
        primary_key=True,
        autoincrement=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_structure",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    parent_id = Column(
        Integer(),
        ForeignKey(
            'structure.id',
            name='fk_structure_parent_id',
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
        backref=backref('structure', uselist=False, cascade="all,delete"),
        foreign_keys=[resource_id],
        cascade="all,delete",
        uselist=False
    )

    children = relationship(
        'Structure',
        backref=backref(
            'parent',
            remote_side=[id]
        ),
        uselist=True,
        lazy='dynamic',
    )
    contacts = relationship(
        'Contact',
        secondary=structure_contact,
        backref=backref('structure', uselist=False),
        cascade="all,delete",
        uselist=True,
    )
    addresses = relationship(
        'Address',
        secondary=structure_address,
        backref=backref('structure', uselist=False),
        cascade="all,delete",
        uselist=True,
    )
    banks_details = relationship(
        'BankDetail',
        secondary=structure_bank_detail,
        backref=backref('structure', uselist=False),
        cascade="all,delete",
        uselist=True,
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

    def get_all_descendants(self):
        all_structures = DBSession.query(Structure)
        structures = {}

        for item in all_structures:
            item_children = structures.setdefault(item.parent_id, [])
            item_children.append(item)
            structures[item.parent_id] = item_children

        def recurse_accumulate(item, result):
            if structures.get(item.id):
                for item in structures.get(item.id):
                    result.append(item)
                    recurse_accumulate(item, result)
            return result

        if structures.get(self.id):
            result = []
            return recurse_accumulate(self, result)

    def __repr__(self):
        return u"<Structure id=%d>" % self.id
