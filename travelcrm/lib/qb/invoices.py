# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.invoice import Invoice
from ...models.bank_detail import BankDetail
from ...models.bank import Bank
from ...models.currency import Currency
from ...models.resource_type import ResourceType

from ...lib.bl.invoices import get_invoices_factories_resources_types


def _query_resource_data():
    factories = get_invoices_factories_resources_types()
    res = None
    for i, factory in enumerate(factories):
        if not i:
            res = factory.query_list()
        else:
            res.union(factory.query_list())
    return res


class InvoicesQueryBuilder(ResourcesQueryBuilder):
    _subq_resource_type = (
        DBSession.query(ResourceType.humanize, Resource.id)
        .join(Resource, ResourceType.resources)
        .subquery()
    )

    _subq_resource_data = _query_resource_data().subquery()

    _fields = {
        'id': Invoice.id,
        '_id': Invoice.id,
        'date': Invoice.date,
        'bank': Bank.name,
        'resource_type': _subq_resource_type.c.humanize,
        'customer': _subq_resource_data.c.customer,
        'sum': _subq_resource_data.c.sum,
        'currency': Currency.iso_code,
    }
    _simple_search_fields = [
        Invoice.date,
        Bank.name,
        _subq_resource_data.c.customer,
        _subq_resource_type.c.humanize
    ]

    def __init__(self, context):
        super(InvoicesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Invoice, Resource.invoice)
            .join(BankDetail, Invoice.bank_detail)
            .join(Bank, BankDetail.bank)
            .join(Currency, BankDetail.currency)
            .join(
                self._subq_resource_type,
                self._subq_resource_type.c.id
                == Invoice.invoice_resource_id
            )
            .join(
                self._subq_resource_data,
                self._subq_resource_data.c.resource_id
                == Invoice.invoice_resource_id
            )
        )

        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Invoice.id.in_(id))
