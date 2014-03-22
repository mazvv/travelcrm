# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder
from .contacts import ContactsQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.bperson import BPerson
from ...models.contact import Contact


class BPersonsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': BPerson.id,
        '_id': BPerson.id,
        'name': BPerson.name,
        'position_name': BPerson.position_name
    }

    _simple_search_fields = [
        BPerson.first_name,
        BPerson.last_name,
        BPerson.position_name,
    ]

    def __init__(self, context):
        super(BPersonsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(BPerson, Resource.bperson)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(BPerson.id.in_(id))
