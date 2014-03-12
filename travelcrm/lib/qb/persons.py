# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from .contacts import ContactsQueryBuilder

from ...models.resource import Resource
from ...models.contact import Contact
from ...models.person import Person


class PersonsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Person.id,
        '_id': Person.id,
        'name': Person.name
    }

    _simple_search_fields = [
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


class PersonsContactsQueryBuilder(ContactsQueryBuilder):

    def filter_relation(self, person_id):
        self.query = (
            self.query
            .join(Person, Contact.person)
            .filter(Person.id == person_id)
        )
