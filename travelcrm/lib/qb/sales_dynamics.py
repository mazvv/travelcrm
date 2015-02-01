# -*coding: utf-8-*-

from sqlalchemy import func

from ...models.invoice import Invoice
from .invoices import InvoicesQueryBuilder


class SalesDynamicsQueryBuilder(InvoicesQueryBuilder):

    def __init__(self, context):
        super(SalesDynamicsQueryBuilder, self).__init__(context)

    def build_query(self):
        super(SalesDynamicsQueryBuilder, self).build_query()
        base_currency_field = (
            func.sum(self._subq_resource_data.c.sum).label('base_sum')
        )
        self.query = self.query.add_columns(base_currency_field)
        self.query = self.query.with_entities(base_currency_field, Invoice.date)
        self.query = self.query.group_by(Invoice.date)

    def filter_paid(self, date_start, date_end):
        self.query = self.query.filter(
            Invoice.date.between(date_start, date_end),
            func.coalesce(self._sum_payments.c.sum, 0) >= self._subq_invoice_sum
        )
