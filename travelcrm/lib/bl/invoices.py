# -*coding: utf-8-*-

from ...models.invoice import Invoice


def get_invoice_payments_sum(invoice_id):
    invoice = Invoice.get(invoice_id)
    return reduce(lambda s, item: s + item.sum, invoice.incomes, 0)
