# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.licence import Licence


class LicencesQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Licence.id,
        '_id': Licence.id,
        'licence_num': Licence.licence_num,
        'date_from': Licence.date_from,
        'date_to': Licence.date_to,
    }

    _simple_search_fields = [
        Licence.licence_num
    ]

    def __init__(self, context):
        super(LicencesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Licence, Resource.licence)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Licence.id.in_(id))
