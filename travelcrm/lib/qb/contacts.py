# -*coding: utf-8-*-

from abc import ABCMeta
from collections import (
    OrderedDict,
    Iterable
)

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.contact import Contact


class ContactsQueryBuilder(ResourcesQueryBuilder):
    __metaclass__ = ABCMeta

    _fields = OrderedDict({
        'id': Contact.id,
        '_id': Contact.id,
        'contact_type': Contact.contact_type,
        'contact': Contact.contact,
    })

    def __init__(self, context):
        super(ContactsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Contact, Resource.contact)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Contact.id.in_(id))
