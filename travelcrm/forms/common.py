#-*-coding:utf-8-*-

import colander

from ..models.account import Account
from ..models.service import Service
from ..models.country import Country
from ..models.location import Location
from ..models.region import Region
from ..models.currency import Currency
from ..models.supplier import Supplier
from ..models.employee import Employee
from ..models.position import Position
from ..models.subaccount import Subaccount
from ..models.account_item import AccountItem
from ..models.bank import Bank
from ..lib.utils.common_utils import translate as _
from ..lib.utils.common_utils import cast_int


@colander.deferred
def account_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        account = Account.get(value)
        if not account:
            raise colander.Invalid(
                node,
                _(u'Account does not exists'),
            )
    return validator


@colander.deferred
def service_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        service = Service.get(value)
        if not service:
            raise colander.Invalid(
                node,
                _(u'Service does not exists'),
            )
    return validator


@colander.deferred
def country_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        country = Country.get(value)
        if not country:
            raise colander.Invalid(
                node,
                _(u'Country does not exists'),
            )
    return validator


@colander.deferred
def currency_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        currency = Currency.get(value)
        if not currency:
            raise colander.Invalid(
                node,
                _(u'Currency does not exists'),
            )
    return validator


@colander.deferred
def supplier_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        supplier = Supplier.get(value)
        if not supplier:
            raise colander.Invalid(
                node,
                _(u'Supplier does not exists'),
            )
    return validator


@colander.deferred
def location_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        location = Location.get(value)
        if not location:
            raise colander.Invalid(
                node,
                _(u'Location does not exists'),
            )
    return validator


@colander.deferred
def region_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        region = Region.get(value)
        if not region:
            raise colander.Invalid(
                node,
                _(u'Region does not exists'),
            )
    return validator


@colander.deferred
def employee_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        employee = Employee.get(value)
        if not employee:
            raise colander.Invalid(
                node,
                _(u'Employee does not exists'),
            )
    return validator


@colander.deferred
def position_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        position = Position.get(value)
        if not position:
            raise colander.Invalid(
                node,
                _(u'Position does not exists'),
            )
    return validator


@colander.deferred
def bank_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        bank = Bank.get(value)
        if not bank:
            raise colander.Invalid(
                node,
                _(u'Bank does not exists'),
            )
    return validator


@colander.deferred
def subaccount_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        subaccount = Subaccount.get(value)
        if not subaccount:
            raise colander.Invalid(
                node,
                _(u'Subaccount does not exists'),
            )
    return validator


@colander.deferred
def account_item_validator(node, kw):

    def validator(node, value):
        value = cast_int(value)
        account_item = AccountItem.get(value)
        if not account_item:
            raise colander.Invalid(
                node,
                _(u'Account Item does not exists'),
            )
    return validator
