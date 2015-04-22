# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Crosspayment(Base):
    __tablename__ = 'crosspayment'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_crosspayment",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    cashflow_id = Column(
        Integer,
        ForeignKey(
            'cashflow.id',
            name="fk_cashflow_id_crosspayment",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    descr = Column(
        String(255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'crosspayment',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False
    )
    cashflow = relationship(
        'Cashflow',
        backref=backref(
            'crosspayment',
            uselist=False,
            cascade="all,delete",
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
    def by_resource_id(cls, resource_id):
        if resource_id is None:
            return None
        return (
            DBSession.query(cls).filter(cls.resource_id == resource_id).first()
        )

    def __repr__(self):
        return "%s_%s: %s" % (self.__class__.__name__, self.id, self.sum)
