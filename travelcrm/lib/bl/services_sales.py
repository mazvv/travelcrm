# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.resource import Resource
from ...models.service_sale import ServiceSale
from ...models.service_item import ServiceItem
from ...models.person import Person
from ...models.invoice import Invoice
from ...models.service import Service
from ...models.currency import Currency
from ...models.account_item import AccountItem
from ...models.liability import Liability
from ...models.liability_item import LiabilityItem

from ...lib.bl import (
    InvoiceFactory,
    LiabilityFactory
)
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
                money_cast(subq.c.base_price / rate).label('unit_price'),
                money_cast(func.sum(subq.c.base_price) / rate).label('price')
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
                money_cast(func.sum(subq.c.base_price) / rate).label('price')
            )
            .group_by(subq.c.id, subq.c.name)
            .order_by(subq.c.name)
        )


class ServiceSaleLiabilityFactory(LiabilityFactory):

    @classmethod
    def _get_resource(cls, resource_id):
        return (
            DBSession.query(ServiceSale)
            .filter(ServiceSale.resource_id == resource_id)
            .first()
        )

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
        subq_liability = (
            DBSession.query(
                Liability.id,
                money_cast(
                    func.coalesce(
                        func.sum(LiabilityItem.base_price), 0
                    )
                ).label('base_price')
            )
            .join(LiabilityItem, Liability.liabilities_items)
            .group_by(Liability.id)
            .subquery()
        )
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                subq_services.c.base_price.label('resource_sum'),
                (subq_services.c.base_price - subq_liability.c.base_price)
                .label('profit'),
                subq_liability.c.base_price.label('base_price'),
                Liability.id.label('liability_id'),
            )
            .join(Resource, ServiceSale.resource)
            .join(Liability, ServiceSale.liability)
            .join(subq_liability, subq_liability.c.id == Liability.id)
            .outerjoin(subq_services, subq_services.c.id == ServiceSale.id)
        )
        return query

    @classmethod
    def bind_liability(cls, resource_id, liability):
        service_sale = cls._get_resource(resource_id)
        service_sale.liability = liability
        return service_sale

    @classmethod
    def get_source_date(cls, resource_id):
        service_sale = cls._get_resource(resource_id)
        return service_sale.deal_date

    @classmethod
    def get_liability(cls, resource_id):
        service_sale = cls._get_resource(resource_id)
        return service_sale.liability

    @classmethod
    def services_info(cls, resource_id):
        service_sale = cls._get_resource(resource_id)
        return (
            DBSession.query(
                Service.id.label('id'),
                Service.name.label('name'),
                func.sum(ServiceItem.price).label('price'),
                Currency.iso_code.label('currency'),
                Currency.id.label('currency_id'),
                ServiceItem.touroperator_id.label('touroperator_id'),
            )
            .join(ServiceSale, ServiceItem.service_sale)
            .join(Service, ServiceItem.service)
            .join(Currency, ServiceItem.currency)
            .filter(ServiceSale.id == service_sale.id)
            .group_by(
                Service.id,
                Service.name,
                Currency.id,
                Currency.iso_code,
                ServiceItem.touroperator_id,
            )
            .order_by(Service.name)
        )
