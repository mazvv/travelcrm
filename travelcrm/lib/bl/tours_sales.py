# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.resource import Resource
from ...models.tour_sale import TourSale
from ...models.person import Person
from ...models.invoice import Invoice
from ...models.service import Service
from ...models.account_item import AccountItem
from ...models.service_item import ServiceItem
from ...models.calculation import Calculation

from ...lib.bl import (
    InvoiceFactory,
    CalculationFactory,
)
from ...lib.bl.currencies_rates import query_convert_rates
from ...lib.utils.common_utils import money_cast


class TourSaleInvoiceFactory(InvoiceFactory):

    @classmethod
    def bind_invoice(cls, resource_id, invoice):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        tour_sale.invoice = invoice
        return tour_sale

    @classmethod
    def get_invoice(cls, resource_id):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        return tour_sale.invoice

    @classmethod
    def get_customer_resource(cls, resource_id):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        return tour_sale.customer.resource
        
    @classmethod
    def get_base_sum(cls, resource_id):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        return tour_sale.base_sum

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Person.name.label('customer'),
                ServiceItem.base_price.label('sum'),
                Invoice.id.label('invoice_id'),
            )
            .join(Resource, TourSale.resource)
            .join(ServiceItem, TourSale.service_item)
            .join(Person, TourSale.customer)
            .join(Invoice, TourSale.invoice)
        )
        return query

    @classmethod
    def services_info(cls, resource_id, currency_id=None):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        rate = query_convert_rates(currency_id, tour_sale.deal_date).scalar()
        if not rate:
            rate = 1
        query = (
            DBSession.query(
                Service.id.label('id'),
                Service.name.label('name'),
                ServiceItem.base_price.label('base_price')
            )
            .join(ServiceItem, TourSale.service_item)
            .join(Service, ServiceItem.service)
            .filter(TourSale.id == tour_sale.id)
        )
        subq = query.subquery()
        return (
            DBSession.query(
                subq.c.name,
                func.count(subq.c.id).label('cnt'),
                money_cast(subq.c.base_price / rate).label('unit_price'),
                money_cast(func.sum(subq.c.base_price) / rate).label('price')
            )
            .group_by(subq.c.id, subq.c.name, subq.c.base_price)
            .order_by(subq.c.name)
        )

    @classmethod
    def accounts_items_info(cls, resource_id, currency_id=None):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        rate = query_convert_rates(currency_id, tour_sale.deal_date).scalar()
        if not rate:
            rate = 1
        query = (
            DBSession.query(
                AccountItem.id.label('id'),
                AccountItem.name.label('name'),
                ServiceItem.base_price.label('base_price')
            )
            .join(ServiceItem, TourSale.service_item)
            .join(Service, ServiceItem.service)
            .join(AccountItem, Service.account_item)
            .filter(TourSale.id == tour_sale.id)
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


class TourSaleCalculationFactory(CalculationFactory):

    @classmethod
    def get_calculations(cls, resource_id):
        services_items = cls.get_services_items(resource_id)
        service_item = services_items[0]
        if not service_item.calculation:
            return []
        return [service_item.calculation, ]

    @classmethod
    def get_services_items(cls, resource_id):
        service_item = (
            DBSession.query(ServiceItem)
            .join(ServiceItem, TourSale.service_item)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        return [service_item, ]

    @classmethod
    def get_date(cls, resource_id):
        tour_sale = (
            DBSession.query(TourSale)
            .filter(TourSale.resource_id == resource_id)
            .first()
        )
        return tour_sale.deal_date

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
            )
            .join(Resource, TourSale.resource)
            .join(ServiceItem, TourSale.service_item)
            .join(Calculation, ServiceItem.calculation)
        )
        return query
