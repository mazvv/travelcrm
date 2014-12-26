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


class EmailCampaign(Base):
    __tablename__ = 'email_campaign'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )
    resource_id = Column(
        Integer,
        ForeignKey(
            'resource.id',
            name="fk_resource_id_email_campaign",
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
        nullable=False,
    )
    html_content = Column(
        Text(),
        nullable=False,
    )
    start_dt = Column(
        DateTime(),
        nullable=False,
    )
    resource = relationship(
        'Resource',
        backref=backref(
            'email_campaign',
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
