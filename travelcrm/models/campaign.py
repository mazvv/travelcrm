# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    ForeignKey,
)
from sqlalchemy.orm import relationship, backref

from ..models import (
    DBSession,
    Base
)
from ..lib import EnumIntType
from ..lib.utils.common_utils import translate as _


class Campaign(Base):
    __tablename__ = 'campaign'

    STATUS = (
        ('awaiting', _(u'awaiting')),
        ('in_work', _(u'in work')),
        ('ready', _(u'ready')),
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
            name="fk_resource_id_campaign",
            ondelete='restrict',
            onupdate='cascade',
        ),
        nullable=False,
    )
    person_category_id = Column(
        Integer,
        ForeignKey(
            'person_category.id',
            name="fk_person_category_id_campaign",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    mail_id = Column(
        Integer,
        ForeignKey(
            'mail.id',
            name="fk_mail_id_campaign",
            ondelete='restrict',
            onupdate='cascade',
        ),
    )
    name = Column(
        String(length=32),
        nullable=False,
    )
    start_dt = Column(
        DateTime(timezone=True),
        nullable=False,
    )
    status = Column(
        EnumIntType(STATUS),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'campaign',
            uselist=False,
            cascade="all,delete"
        ),
        cascade="all,delete",
        uselist=False,
    )
    person_category = relationship(
        'PersonCategory',
        backref=backref(
            'campaigns',
            lazy='dynamic',
        ),
        cascade="all,delete",
        uselist=False,
    )
    mail = relationship(
        'Mail',
        backref=backref(
            'mails',
            lazy='dynamic',
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

    def set_status_ready(self):
        self.status = 'ready'

    def is_status_ready(self):
        return self.status == 'ready'

    def set_status_in_work(self):
        self.status = 'in_work'

    def is_status_in_work(self):
        return self.status == 'in_work'
