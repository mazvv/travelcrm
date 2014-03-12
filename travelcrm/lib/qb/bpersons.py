# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from .contacts import ContactsQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.bperson import BPerson
from ...models.tbperson import TBPerson
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

    def filter_relation(self, relation_id):
        raise NotImplementedError()

    def union_temporal(self, temporal_id, relation_id):
        fields = self._fields.copy()
        fields['id'] = -BPerson.id
        fields['_id'] = BPerson.id
        fields['name'] = BPerson.name
        fields['position_name'] = BPerson.position_name

        fields = ResourcesQueryBuilder.get_fields_with_labels(fields)

        subq = DBSession.query(TBPerson.main_id)
        subq = subq.filter(
            TBPerson.temporal_id == temporal_id,
            TBPerson.main_id != None
        )
        subq = subq.subquery()

        self.filter_relation(relation_id)
        self.query = self.query.filter(~BPerson.id.in_(subq))
        union_query = (
            DBSession.query(*fields)
            .join(TBPerson, BPerson.temporals)
            .filter(TBPerson.temporal_id == temporal_id)
            .filter(TBPerson.deleted == False)
        )
        self.query = self.query.union(union_query)


class BPersonsContactsQueryBuilder(ContactsQueryBuilder):

    def filter_relation(self, bperson_id):
        self.query = (
            self.query
            .join(BPerson, Contact.bperson)
            .filter(BPerson.id == bperson_id)
        )
