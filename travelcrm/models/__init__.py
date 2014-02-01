# coding: utf-8

import datetime

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
)
from zope.sqlalchemy import ZopeTransactionExtension

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))


Base = declarative_base()

from resource_type import ResourceType
from resource import Resource
from group import Group
from user import User
from resource_log import ResourceLog
from group_navigation import GroupNavigation
from group_permission import GroupPermision
from region import Region
from currency import Currency
from attachment import Attachment
from employee import Employee
from company import Company
from company_struct import CompanyStruct
from company_position import CompanyPosition
from position_permision import PositionPermision
from position_navigation import PositionNavigation
from employee_appointment import (
    EmployeeAppointmentHeader, EmployeeAppointmentRows
)
