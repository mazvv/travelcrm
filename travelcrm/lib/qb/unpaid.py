# -*coding: utf-8-*-

from datetime import date

from sqlalchemy import func

from ...models.invoice import Invoice
from ...lib.qb.invoice import InvoiceQueryBuilder


class UnpaidQueryBuilder(InvoiceQueryBuilder):

    def filter_unpaid(self):
        self.query = self.query.filter(
            Invoice.active_until < date.today(),
            func.coalesce(self._sum_payments.c.sum, 0) 
            < self._subq_invoice_sum,
        )
