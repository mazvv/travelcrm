# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.lead import Lead
from ...models.person import Person
from ...models.advsource import Advsource
from ...models.lead_item import LeadItem
from ...models.order import Order


class LeadsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(LeadsQueryBuilder, self).__init__(context)
        
        self._fields = {
            'id': Lead.id,
            '_id': Lead.id,
            'lead_date': Lead.lead_date,
            'customer': Person.name,
            'order': Order.id,
            'advsource': Advsource.name,
            'status': Lead.status,
        }
        self._simple_search_fields = [
            Person.first_name,
            Person.last_name,
            Person.name
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .distinct(Lead.id)
            .join(Lead, Resource.lead)
            .join(Person, Lead.customer)
            .join(Advsource, Lead.advsource)
            .join(LeadItem, Lead.leads_items)
            .outerjoin(Order, Lead.order)
        )
        super(LeadsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Lead.id.in_(id))

    def advanced_search(self, **kwargs):
        super(LeadsQueryBuilder, self).advanced_search(**kwargs)
        if 'advsource_id' in kwargs:
            self._filter_advsource(kwargs.get('advsource_id'))
        if 'service_id' in kwargs:
            self._filter_service(kwargs.get('service_id'))
        if 'status' in kwargs:
            self._filter_status(kwargs.get('status'))
        if 'currency_id' in kwargs:
            self._filter_currency(kwargs.get('currency_id'))
        if 'price_from' in kwargs or 'price_to' in kwargs:
            self._filter_price(
                kwargs.get('price_from'), kwargs.get('price_to')
            )
        if 'lead_from' in kwargs or 'lead_to' in kwargs:
            self._filter_lead_date(
                kwargs.get('lead_from'), kwargs.get('lead_to')
            )

    def _filter_advsource(self, advsource_id):
        if advsource_id:
            self.query = self.query.filter(Lead.advsource_id == advsource_id)

    def _filter_service(self, service_id):
        if service_id:
            self.query = self.query.filter(LeadItem.service_id == service_id)

    def _filter_currency(self, currency_id):
        if currency_id:
            self.query = self.query.filter(LeadItem.currency_id == currency_id)

    def _filter_status(self, status):
        if status:
            self.query = self.query.filter(Lead.status == status)

    def _filter_price(self, price_from, price_to):
        if price_from:
            self.query = self.query.filter(
                func.coalesce(LeadItem.price_from, 0) >= price_from,
            )
        if price_to:
            self.query = self.query.filter(
                func.coalesce(LeadItem.price_to, 0) <= price_to,
            )

    def _filter_lead_date(self, date_from, date_to):
        if date_from:
            self.query = self.query.filter(
                Lead.lead_date >= date_from
            )
        if date_to:
            self.query = self.query.filter(
                Lead.lead_date <= date_to
            )
