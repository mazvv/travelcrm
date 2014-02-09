# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
    )
from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.hybrid import hybrid_property

from ..models import (
    DBSession,
    Base
)


class Employee(Base):
    __tablename__ = 'employee'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_employee",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    attachment_id = Column(
        Integer,
        ForeignKey(
            'attachment.id',
            name="fk_attachment_id_employee",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=True,
    )
    first_name = Column(
        String(length=32),
        nullable=False,
    )
    last_name = Column(
        String(length=32),
        nullable=False,
    )
    second_name = Column(
        String(length=32),
    )

    resource = relationship(
        'Resource',
        backref=backref('employee', uselist=False, cascade="all,delete"),
        cascade="all,delete",
        uselist=False,
    )

    photo = relationship(
        'Attachment',
        backref=backref('employee', uselist=False, cascade="all,delete"),
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
