# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.person import Person


class PersonsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Person.id,
        '_id': Person.id,
        'name': Person.name
    }

    _simple_search_fields = [
        Person.name,
        Person.first_name,
        Person.last_name,
    ]

    def __init__(self, context):
        super(PersonsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Person, Resource.person)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Person.id.in_(id))
