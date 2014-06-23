# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.resource import Resource
from ...models.service_sale import ServiceSale
from ...models.service_item import ServiceItem
from ...models.person import Person
from ...models.invoice import Invoice
from ...models.fin_transaction import FinTransaction
from ...models.service import Service
from ...models.account_item import AccountItem

from ...lib.bl.invoices import query_invoice_payments_accounts_items_grouped
from ...lib.bl.currencies_rates import query_convert_rates
from ...lib.utils.common_utils import money_cast


def calc_base_price(service_sale):
    assert isinstance(service_sale, ServiceSale), \
        u"Must be ServiceSale instance"
    for service_item in service_sale.services_items:
        base_service_rate = (
            query_convert_rates(
                service_item.currency_id, service_sale.deal_date
            )
            .scalar()
        )
        if base_service_rate is None:
            base_service_rate = 1
        service_item.base_price = money_cast(
            base_service_rate * service_item.price
        )
    return service_sale


class ServiceSaleInvoice(object):

    @classmethod
    def bind_invoice(cls, resource_id, invoice):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        service_sale.invoice = invoice
        return service_sale

    @classmethod
    def get_invoice(cls, resource_id):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        return service_sale.invoice

    @classmethod
    def get_base_sum(cls, resource_id):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        return service_sale.base_sum

    @classmethod
    def query_list(cls):
        subq_services = (
            DBSession.query(
                ServiceSale.id,
                func.sum(ServiceItem.base_price).label('base_price')
            )
            .join(ServiceSale, ServiceItem.service_sale)
            .group_by(ServiceSale.id)
            .subquery()
        )
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Person.name.label('customer'),
                subq_services.c.base_price.label('sum'),
                Invoice.id.label('invoice_id'),
            )
            .join(Resource, ServiceSale.resource)
            .join(Person, ServiceSale.customer)
            .join(Invoice, ServiceSale.invoice)
            .outerjoin(subq_services, subq_services.c.id == ServiceSale.id)
        )
        return query

    @classmethod
    def make_payment(cls, invoice_id, date, sum):
        invoice = Invoice.get(invoice_id)
        currency = invoice.account.currency
        service_sale = invoice.service_sale
        transacts = []
        payments_query = (
            query_invoice_payments_accounts_items_grouped(invoice.id)
        )
        payments = {item.account_item_id: item.sum for item in payments_query}
        accounts_items_info = cls.accounts_items_info(
            service_sale.resource_id, currency.id
        )
        for account_item in accounts_items_info:
            account_item_payments = payments.get(account_item.id, 0)
            debt = account_item.price - account_item_payments
            if debt <= sum:
                sum_to_pay = debt
            else:
                sum_to_pay = sum
            transact = FinTransaction(
                account_item_id=account_item.id,
                date=date,
                sum=sum_to_pay
            )
            sum -= sum_to_pay
            transacts.append(transact)
            if sum <= 0:
                break
        return transacts

    @classmethod
    def services_info(cls, resource_id, currency_id=None):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        rate = query_convert_rates(currency_id, ServiceSale.deal_date).scalar()
        if not rate:
            rate = 1
        query = (
            DBSession.query(
                Service.id.label('id'),
                Service.name.label('name'),
                ServiceItem.base_price.label('base_price')
            )
            .join(ServiceSale, ServiceItem.service_sale)
            .join(Service, ServiceItem.service)
            .filter(ServiceSale.id == service_sale.id)
        )
        subq = query.subquery()
        return (
            DBSession.query(
                subq.c.id,
                subq.c.name,
                func.count(subq.c.id).label('cnt'),
                money_cast(func.sum(subq.c.base_price) / rate).label('price')
            )
            .group_by(subq.c.id, subq.c.name)
            .order_by(subq.c.name)
        )

    @classmethod
    def accounts_items_info(cls, resource_id, currency_id=None):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        rate = query_convert_rates(currency_id, ServiceSale.deal_date).scalar()
        if not rate:
            rate = 1
        query = (
            DBSession.query(
                AccountItem.id.label('id'),
                AccountItem.name.label('name'),
                ServiceItem.base_price.label('base_price')
            )
            .join(ServiceSale, ServiceItem.service_sale)
            .join(Service, ServiceItem.service)
            .join(AccountItem, Service.account_item)
            .filter(ServiceSale.id == service_sale.id)
        )
        subq = query.subquery()
        return (
            DBSession.query(
                subq.c.id,
                subq.c.name,
                func.count(subq.c.id).label('cnt'),
                money_cast(func.sum(subq.c.base_price) / rate).label('price')
            )
            .group_by(subq.c.id, subq.c.name)
            .order_by(subq.c.name)
        )
