# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.dialects.postgresql import ENUM

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
    country_id = Column(
        Integer,
        ForeignKey(
            'country.id',
            name="fk_country_id_passport",
            ondelete='cascade',
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
        String,
        nullable=False
    )
    descr = Column(
        String,
    )

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)
