# coding: utf-8

import datetime

from sqlalchemy.orm import (
    make_transient,
    scoped_session,
    sessionmaker,
)
from sqlalchemy.ext.declarative import declarative_base
from zope.sqlalchemy import ZopeTransactionExtension


DBSession = scoped_session(
    sessionmaker(
        extension=ZopeTransactionExtension(),
        autoflush=False,
    ),
)


class _BaseCls(object):
    @classmethod
    def get_copy(cls, id):
        inst = cls.get(id)
        if not inst:
            return inst
        DBSession.expunge(inst)
        make_transient(inst)
        inst.id = None
        return inst


Base = declarative_base(cls=_BaseCls)

from resource_type import ResourceType
from resource import Resource
from user import User
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
from supplier import Supplier
from contract import Contract
from passport import Passport
from hotel import Hotel
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
from commission import Commission
from outgoing import Outgoing
from crosspayment import Crosspayment
from note import Note
from calculation import Calculation
from cashflow import Cashflow
from notification import Notification
from company import Company
from lead import Lead
from order import Order
from order_item import OrderItem
from transfer import Transfer
from tour import Tour
from transport import Transport
from supplier_type import SupplierType
from ticket import Ticket
from ticket_class import TicketClass
from visa import Visa
from spassport import Spassport
from lead_item import LeadItem
from lead_offer import LeadOffer
from invoice_item import InvoiceItem
from vat import Vat
from upload import Upload
from person_category import PersonCategory
from campaign import Campaign
from dismissal import Dismissal
from mail import Mail
from tag import Tag
