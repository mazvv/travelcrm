# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


bperson_contact = Table(
    'bperson_contact',
    Base.metadata,
    Column(
        'bperson_id',
        Integer,
        ForeignKey(
            'bperson.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_bperson_id_bperson_contact',
        ),
        primary_key=True,
    ),
    Column(
        'contact_id',
        Integer,
        ForeignKey(
            'contact.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_contact_id_bperson_contact',
        ),
        primary_key=True,
    )
)


class BPerson(Base):
    __tablename__ = 'bperson'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_bperson",
            ondelete='restrict',
            onupdate='cascade',
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
    resource = relationship(
        'Resource',
        backref=backref(
            'bperson',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    contacts = relationship(
        'Contact',
        secondary=bperson_contact,
        backref=backref(
            'bperson',
            uselist=False
        ),
        uselist=True,
    )

    @hybrid_property
    def name(self):
        return self.last_name + " " + self.first_name

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
