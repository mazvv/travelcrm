# -*coding: utf-8-*-

from sqlalchemy import func, distinct

from ...models import DBSession
from ...models.resource import Resource
from ...models.tour import Tour
from ...models.service_sale import ServiceSale
from ...models.service_item import ServiceItem
from ...models.person import Person
from ...models.invoice import Invoice
from ...models.fin_transaction import FinTransaction


class ServiceSaleInvoice(object):

    @classmethod
    def bind_invoice(cls, resource_id, invoice):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        service_sale.invoice = invoice
        return service_saler

    @classmethod
    def get_invoice(cls, resource_id):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        return service_sale.invoice

    @classmethod
    def get_sum(cls, resource_id):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        currencies = (
            DBSession(func.count(distinct(ServiceItem.currency_id)))
            .join(ServiceItem, ServiceSale.services_items)
            .group_by(ServiceItem.currency_id)
            .scalar()
        )
        return service_sale.price, service_sale.currency_id

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
