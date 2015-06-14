# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.contact import Contact


class ContactsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(ContactsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Contact.id,
            '_id': Contact.id,
            'contact_type': Contact.contact_type,
            'contact': Contact.contact,
            'status': Contact.status,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Contact, Resource.contact)
        super(ContactsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Contact.id.in_(id))
