# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.person import Person


class PersonsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Person.id,
        '_id': Person.id,
        'name': Person.name
    }

    def __init__(self, context):
        super(PersonsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Person, Resource.person)
        self.query = self.query.add_columns(*fields)
