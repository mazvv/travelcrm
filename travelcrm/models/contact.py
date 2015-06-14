# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _
from ..models import (
    DBSession,
    Base
)


class Contact(Base):
    __tablename__ = 'contact'

    CONTACT_TYPE = (
        ('phone', _(u'phone')),
        ('email', _(u'email')),
        ('skype', _(u'skype')),
    )
    STATUS = (
        ('active', _(u'active')),
        ('unactive', _(u'unactive')),
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
            name="fk_resource_id_contact",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    contact_type = Column(
        EnumIntType(CONTACT_TYPE),
        nullable=False,
    )
    contact = Column(
        String,
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        default='active',
        nullable=False,
    )
    descr = Column(
        String(255),
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'contact',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
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
    def condition_email(cls):
        return cls.contact_type == u'email'

    @classmethod
    def condition_phone(cls):
        return cls.contact_type == u'phone'

    @classmethod
    def condition_skype(cls):
        return cls.contact_type == u'skype'

    @classmethod
    def condition_status_active(cls):
        return cls.status == u'active'

    def is_status_active(self):
        return self.status == u'active'
