# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
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
    name = Column(
        String(length=32),
        nullable=False,
    )
    subject = Column(
        String(length=128),
        nullable=False,
    )
    plain_content = Column(
        Text(),
    )
    html_content = Column(
        Text(),
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
