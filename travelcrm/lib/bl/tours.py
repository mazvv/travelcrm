# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.tour import Tour
from ...models.person import Person
from ...models.invoice import Invoice
from ...models.fin_transaction import FinTransaction


class TourInvoice(object):

    @classmethod
    def bind_invoice(cls, resource_id, invoice):
        tour = (
            DBSession.query(Tour)
            .filter(Tour.resource_id == resource_id)
            .first()
        )
        tour.invoice = invoice
        return tour

    @classmethod
    def get_invoice(cls, resource_id):
        tour = (
            DBSession.query(Tour)
            .filter(Tour.resource_id == resource_id)
            .first()
        )
        return tour.invoice

    @classmethod
    def get_sum(cls, resource_id):
        tour = (
            DBSession.query(Tour)
            .filter(Tour.resource_id == resource_id)
            .first()
        )
        return tour.price, tour.currency_id

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Person.name.label('customer'),
                Tour.price.label('sum'),
                Tour.currency_id.label('currency_id'),
                Invoice.id.label('invoice_id'),
            )
            .join(Resource, Tour.resource)
            .join(Person, Tour.customer)
            .join(Invoice, Tour.invoice)
        )
        return query

    @classmethod
    def make_payment(cls, invoice_id, date, sum):
        invoice = Invoice.get(invoice_id)
        tour = invoice.tour
        transact = FinTransaction(
            account_item=tour.service.account_item,
            date=date,
            sum=sum
        )
        return [transact, ]
