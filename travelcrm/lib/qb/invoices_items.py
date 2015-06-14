# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.invoice_item import InvoiceItem
from ...models.service import Service


class InvoicesItemsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(InvoicesItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': InvoiceItem.id,
            '_id': InvoiceItem.id,
            'service': Service.name,
            'price': InvoiceItem.price,
            'discount': InvoiceItem.discount,
            'vat': InvoiceItem.vat,
            'final_price': InvoiceItem.final_price,
            'descr': InvoiceItem.descr,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(InvoiceItem, Resource.invoice_item)
            .join(
                Service,
                InvoiceItem.service
            )
        )
        super(InvoicesItemsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(InvoiceItem.id.in_(id))
