# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    Date,
    ForeignKey,
    func
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Dismissal(Base):
    __tablename__ = 'dismissal'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_dismissal",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    date = Column(
        Date,
        default=func.now()
    )
    employee_id = Column(
        Integer,
        ForeignKey(
            'employee.id',
            name="fk_employee_id_dismissal",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'dismissal',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    employee = relationship(
        'Employee',
        backref=backref(
            'employee_dismissals',
            uselist=True,
            lazy='dynamic'
        ),
        uselist=False,
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

    @classmethod
    def condition_employee_id(cls, employee_id):
        return cls.employee_id == employee_id

