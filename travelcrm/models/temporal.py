# -*-coding: utf-8-*-

from sqlalchemy import (
    Column,
    Integer,
    DateTime,
    func,
    desc
)

from ..models import (
    DBSession,
    Base
)


class Temporal(Base):
    __tablename__ = '_temporal'

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )

    createdt = Column(
        DateTime(timezone=False),
        onupdate=func.now()
    )
    modifydt = Column(
        DateTime(timezone=False),
        default=func.now()
    )

    def __init__(self):
        self.id = self._populate_id()

    @classmethod
    def get(cls, id):
        if id is None:
            return None
        return DBSession.query(cls).get(id)

    def _populate_id(self):
        id = (
            DBSession.query(Temporal.id)
            .order_by(desc(Temporal.id))
            .limit(1).scalar()
        )
        if not id:
            return 1
        return id + 1
