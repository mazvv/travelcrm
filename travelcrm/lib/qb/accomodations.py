# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.accomodation import Accomodation


class AccomodationsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Accomodation.id,
        '_id': Accomodation.id,
        'name': Accomodation.name
    }
    _simple_search_fields = [
        Accomodation.name
    ]

    def __init__(self, context):
        super(AccomodationsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Accomodation, Resource.accomodation)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        if id:
            self.query = self.query.filter(Accomodation.id == id)
