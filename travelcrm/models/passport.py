# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    ForeignKey,
)
from sqlalchemy.dialects.postgresql import ENUM
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)


class Passport(Base):
    __tablename__ = 'passport'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_passport",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    country_id = Column(
        Integer,
        ForeignKey(
            'country.id',
            name="fk_country_id_passport",
            ondelete='restrict',
            onupdate='cascade',
            use_alter=True,
        ),
        nullable=False,
    )
    passport_type = Column(
        ENUM(
            u'citizen', u'foreign',
            name='passport_type_enum', create_type=True,
        ),
        nullable=False,
    )
    num = Column(
        String(length=32),
        nullable=False
    )
    end_date = Column(
        Date(),
    )
    descr = Column(
        String(length=255),
    )

    resource = relationship(
        'Resource',
        backref=backref(
            'passport',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    country = relationship(
        'Country',
        backref=backref(
            'passports',
            uselist=True,
            lazy="dynamic"
        ),
        uselist=False
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
