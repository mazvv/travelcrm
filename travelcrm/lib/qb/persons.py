# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, case

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.person import Person
from ...models.person_category import PersonCategory

from ...lib.bl.persons import query_person_contacts, query_person_passports


class PersonsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(PersonsQueryBuilder, self).__init__(context)
        self._subq_contacts = query_person_contacts().subquery()
        self._subq_passports = query_person_passports().subquery()
        self._fields = {
            'id': Person.id,
            '_id': Person.id,
            'name': Person.name,
            'birthday': Person.birthday,
            'person_category': PersonCategory.name,
            'age': case([(
                Person.birthday != None,
                func.date_part('year', func.age(Person.birthday))
            )]),
        }
        self._simple_search_fields = [
            Person.name,
            Person.first_name,
            Person.last_name,
            self._subq_contacts.c.phone,
            self._subq_contacts.c.email,
            self._subq_contacts.c.skype,
            self._subq_passports.c.citizen,
            self._subq_passports.c.foreign,
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Person, Resource.person)
            .outerjoin(
                self._subq_contacts,
                Person.id == self._subq_contacts.c.person_id
            )
            .outerjoin(
                self._subq_passports,
                Person.id == self._subq_passports.c.person_id
            )
            .outerjoin(
                PersonCategory, Person.person_category
            )
        )
        super(PersonsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Person.id.in_(id))
