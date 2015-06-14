# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.passport import Passport
from ...models.country import Country


class PassportsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(PassportsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Passport.id,
            '_id': Passport.id,
            'passport_country': Country.name,
            'passport_type': Passport.passport_type,
            'passport_num': Passport.num,
            'end_date': Passport.end_date,
            'descr': Passport.descr
        }
        self._simple_search_fields = [
            Passport.num,
            Passport.passport_type,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Passport, Resource.passport)
            .join(Country, Passport.country)
        )
        super(PassportsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Passport.id.in_(id))
