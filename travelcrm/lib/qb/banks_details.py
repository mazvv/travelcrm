# -*coding: utf-8-*-

from collections import (
    OrderedDict,
    Iterable
)

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.bank import Bank
from ...models.bank_detail import BankDetail


class BanksDetailsQueryBuilder(ResourcesQueryBuilder):

    _fields = OrderedDict({
        'id': BankDetail.id,
        '_id': BankDetail.id,
        'bank_name': Bank.name,
        'beneficiary': BankDetail.beneficiary,
        'account': BankDetail.account,
        'swift_code': BankDetail.swift_code
    })

    _simple_search_fields = [
        BankDetail.beneficiary,
        BankDetail.account,
        BankDetail.swift_code,
    ]

    def __init__(self, context):
        super(BanksDetailsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(BankDetail, Resource.bank_detail)
        self.query = self.query.join(Bank, BankDetail.bank)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(BankDetail.id.in_(id))
