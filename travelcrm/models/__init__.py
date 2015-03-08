# coding: utf-8

import re
import datetime

from sqlalchemy import (
    Column,
    Integer,
)
from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
)
from sqlalchemy.ext.declarative import declarative_base, declared_attr
from zope.sqlalchemy import ZopeTransactionExtension

DBSession = scoped_session(
    sessionmaker(
        extension=ZopeTransactionExtension(),
        autoflush=False,
    ),
)

def _to_camelcase(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()


class _Base(object):

    @declared_attr
    def __tablename__(cls):
        return _to_camelcase(cls.__name__)

    id = Column(
        Integer,
        autoincrement=True,
        primary_key=True
    )

    @classmethod
    def get(cls, id):
        return DBSession.query(cls).filter(cls.id == id).first()


Base = declarative_base(cls=_Base)

from resource_type import ResourceType
from resource import Resource
from user import User
from resource_log import ResourceLog
from region import Region
from currency import Currency
from employee import Employee
from structure import Structure
from position import Position
from permision import Permision
from navigation import Navigation
from appointment import Appointment
from person import Person
from country import Country
from address import Address
from contact import Contact
from location import Location
from advsource import Advsource
from hotelcat import Hotelcat
from roomcat import Roomcat
from accomodation import Accomodation
from foodcat import Foodcat
from bperson import BPerson
from touroperator import Touroperator
from licence import Licence
from passport import Passport
from hotel import Hotel
from tour_sale import TourSale
from tour_sale_point import TourSalePoint
from bank import Bank
from bank_detail import BankDetail
from task import Task
from service import Service
from currency_rate import CurrencyRate
from invoice import Invoice
from account_item import AccountItem
from income import Income
from account import Account
from subaccount import Subaccount
from service_item import ServiceItem
from service_sale import ServiceSale
from commission import Commission
from supplier import Supplier
from outgoing import Outgoing
from crosspayment import Crosspayment
from note import Note
from calculation import Calculation
from transfer import Transfer
from notification import Notification
from email_campaign import EmailCampaign
from company import Company
from lead import Lead
