# coding: utf-8

import datetime

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
)
from zope.sqlalchemy import ZopeTransactionExtension

DBSession = scoped_session(
    sessionmaker(
        extension=ZopeTransactionExtension(),
        autoflush=False,
    ),
)


Base = declarative_base()

from resource_type import ResourceType
from resource import Resource
from user import User
from resource_log import ResourceLog
from region import Region
from currency import Currency
from attachment import Attachment
from employee import Employee
from structure import Structure
from position import Position
from permision import Permision
from navigation import Navigation
from appointment import (
    AppointmentHeader,
    AppointmentRow,
)
from person import Person
from country import Country
from address import Address
from contact import Contact
from location import Location
