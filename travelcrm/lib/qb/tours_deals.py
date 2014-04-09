# -*coding: utf-8-*-
from collections import Iterable

from . import (
    ResourcesQueryBuilder,
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.tour import Tour
from ...models.tour_deal import TourDeal
from ...models.person import Person
from ...models.touroperator import Touroperator


class ToursDealsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': TourDeal.id,
        '_id': TourDeal.id,
        'customer_name': Person.name,
    }

    _simple_search_fields = [
        Touroperator.name,
    ]

    def __init__(self, context):
        super(ToursDealsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(TourDeal, Resource.tour_deal)
            .join(Person, TourDeal.customer)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(TourDeal.id.in_(id))
