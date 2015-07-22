# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Date,
    Table,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


passport_upload = Table(
    'passport_upload',
    Base.metadata,
    Column(
        'passport_id',
        Integer,
        ForeignKey(
            'passport.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_passport_id_passport_upload',
        ),
        primary_key=True,
    ),
    Column(
        'upload_id',
        Integer,
        ForeignKey(
            'upload.id',
            ondelete='restrict',
            onupdate='cascade',
            name='fk_upload_id_passport_upload',
        ),
        primary_key=True,
    )
)


class Passport(Base):
    __tablename__ = 'passport'

    PASSPORT_TYPE = (
        ('citizen', _(u'citizen')),
        ('foreign', _(u'foreign')),
    )

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
        ),
        nullable=False,
    )
    passport_type = Column(
        EnumIntType(PASSPORT_TYPE),
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
    uploads = relationship(
        'Upload',
        secondary=passport_upload,
        backref=backref(
            'passport',
            uselist=False
        ),
        cascade="all,delete",
        uselist=True,
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
