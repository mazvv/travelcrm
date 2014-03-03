# -*coding: utf-8-*-

from abc import ABCMeta
from collections import OrderedDict

from . import GeneralQueryBuilder

from ...models import DBSession
from ...models.contact import Contact
from ...models.tcontact import TContact


class ContactsQueryBuilder(GeneralQueryBuilder):
    __metaclass__ = ABCMeta

    _fields = OrderedDict({
        'id': Contact.id,
        '_id': Contact.id,
        'contact_type': Contact.contact_type,
        'contact': Contact.contact,
    })

    def __init__(self):
        fields = GeneralQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = DBSession.query(*fields)

    def filter_contactor(self, contactor_id):
        """ Need to implement it
        Example for person:
        self.query = (
            self.query
            .join(Person, Contact.person)
            .filter(Person.id == contactor_id)
        )
        """
        raise NotImplementedError()

    def union_temporal(self, temporal_id, contactor_id):
        fields = self._fields.copy()
        fields['id'] = -TContact.id
        fields['_id'] = TContact.id
        fields['contact_type'] = TContact.contact_type
        fields['contact'] = TContact.contact

        fields = GeneralQueryBuilder.get_fields_with_labels(fields)

        subq = DBSession.query(TContact.main_id)
        subq = subq.filter(
            TContact.temporal_id == temporal_id,
            TContact.main_id != None
        )
        subq = subq.subquery()

        self.filter_contactor(contactor_id)
        self.query = self.query.filter(~Contact.id.in_(subq))
        union_query = (
            DBSession.query(*fields)
            .filter(TContact.temporal_id == temporal_id)
            .filter(TContact.deleted == False)
        )
        self.query = self.query.union(union_query)
