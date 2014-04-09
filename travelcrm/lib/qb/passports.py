# -*coding: utf-8-*-

from collections import (
    OrderedDict,
    Iterable
)

from sqlalchemy.orm import class_mapper
from sqlalchemy.orm.properties import RelationshipProperty

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.passport import Passport
from ...models.country import Country


class PassportsQueryBuilder(ResourcesQueryBuilder):

    _fields = OrderedDict({
        'id': Passport.id,
        '_id': Passport.id,
        'passport_country': Country.name,
        'passport_type': Passport.passport_type,
        'passport_num': Passport.num,
        'end_date': Passport.end_date,
        'descr': Passport.descr
    })

    _simple_search_fields = [
        Passport.num,
        Passport.passport_type,
    ]

    def __init__(self, context):
        super(PassportsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Passport, Resource.passport)
            .join(Country, Passport.country)
        )
        self.query = self.query.add_columns(*fields)

    def filter_reference(self, ref_name, ref_id):
        for item in class_mapper(Passport).iterate_properties:
            if isinstance(item, RelationshipProperty) and item.key == ref_name:
                ref_cls = item.mapper.class_
                self.query = (
                    self.query
                    .join(ref_cls, getattr(Passport, ref_name))
                    .filter(ref_cls.id == ref_id)
                )
                return
        raise ValueError(
            u"Can't find given ref_name %{ref_name}".format(ref_name)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Passport.id.in_(id))
