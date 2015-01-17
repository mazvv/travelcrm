# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.resource import Resource
from ...models.service_sale import ServiceSale
from ...models.service_item import ServiceItem
from ...models.person import Person
from ...models.invoice import Invoice
from ...models.service import Service
from ...models.account_item import AccountItem
from ...models.calculation import Calculation

from ...lib.bl import (
    InvoiceFactory,
    CalculationFactory,
)
from ...lib.bl.currencies_rates import query_convert_rates


class ServiceSaleInvoiceFactory(InvoiceFactory):

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
    def get_customer_resource(cls, resource_id):
        tour_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        return tour_sale.customer.resource

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
                (subq.c.base_price / rate).label('unit_price'),
                (func.sum(subq.c.base_price) / rate).label('price')
            )
            .group_by(subq.c.id, subq.c.name, subq.c.base_price)
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
                (func.sum(subq.c.base_price) / rate).label('price')
            )
            .group_by(subq.c.id, subq.c.name)
            .order_by(subq.c.name)
        )


class ServiceSaleCalculationFactory(CalculationFactory):

    @classmethod
    def get_calculations(cls, resource_id):
        services_items = cls.get_services_items(resource_id)
        return [service_item.calculation for service_item in services_items]

    @classmethod
    def get_services_items(cls, resource_id):
        return (
            DBSession.query(ServiceItem)
            .join(ServiceItem, ServiceSale.services_items)
            .filter(ServiceSale.resource_id == resource_id)
            .all()
        )

    @classmethod
    def get_date(cls, resource_id):
        service_sale = (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )
        return service_sale.deal_date

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                ServiceSale.deal_date.label('date'),
                ServiceItem.id.label('service_item_id'),
            )
            .join(Resource, ServiceSale.resource)
            .join(ServiceItem, ServiceSale.services_items)
            .join(Calculation, ServiceItem.calculation)
        )
        return query
