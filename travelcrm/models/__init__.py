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
from tour import Tour
from tour_point import TourPoint
from bank import Bank
from bank_detail import BankDetail
from task import Task
from service import Service
from currency_rate import CurrencyRate
from invoice import Invoice
from account_item import AccountItem
from fin_transaction import FinTransaction
from income import Income
from account import Account
from service_item import ServiceItem
from service_sale import ServiceSale
from commission import Commission
