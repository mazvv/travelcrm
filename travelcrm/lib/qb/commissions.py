# -*coding: utf-8-*-

from collections import (
    OrderedDict,
    Iterable
)

from sqlalchemy.orm import class_mapper
from sqlalchemy.orm.properties import RelationshipProperty

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.commission import Commission
from ...models.currency import Currency
from ...models.service import Service


class CommissionsQueryBuilder(ResourcesQueryBuilder):

    _fields = OrderedDict({
        'id': Commission.id,
        '_id': Commission.id,
        'date_from': Commission.date_from,
        'service': Service.name,
        'percentage': Commission.percentage,
        'price': Commission.price,
        'currency': Currency.iso_code,
    })

    def __init__(self, context):
        super(CommissionsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Commission, Resource.commission)
            .join(Service, Commission.service)
            .join(Currency, Commission.currency)
        )
        self.query = self.query.add_columns(*fields)

    def filter_reference(self, ref_name, ref_id):
        for item in class_mapper(Commission).iterate_properties:
            if isinstance(item, RelationshipProperty) and item.key == ref_name:
                ref_cls = item.mapper.class_
                self.query = (
                    self.query
                    .join(ref_cls, getattr(Commission, ref_name))
                    .filter(ref_cls.id == ref_id)
                )
                return
        raise ValueError(
            u"Can't find given ref_name %{ref_name}".format(ref_name)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Commission.id.in_(id))
