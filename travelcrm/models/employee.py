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


class Employee(Base):
    __tablename__ = '_employees'

    rid = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    _resources_rid = Column(
        Integer,
        ForeignKey(
            '_resources.rid',
            name="fk_resources_rid_employees",
            ondelete='cascade',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    _photo_attachments_rid = Column(
        Integer,
        ForeignKey(
            '_attachments.rid',
            name="fk_photo_attachments_rid_employees",
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
    
    @classmethod
    def by_rid(cls, rid):
        return DBSession.query(cls).filter(cls.rid == rid).first()

    @hybrid_property
    def name(self):
        return u"{first_name} {last_name}".format(
            first_name=self.first_name, 
            last_name=self.last_name
        )
