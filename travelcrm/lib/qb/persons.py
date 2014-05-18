# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, case

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.person import Person

from ...lib.bl.persons import query_person_contacts, query_person_passports


class PersonsQueryBuilder(ResourcesQueryBuilder):
    _subq_contacts = query_person_contacts().subquery()
    _subq_passports = query_person_passports().subquery()

    _fields = {
        'id': Person.id,
        '_id': Person.id,
        'name': Person.name,
        'birthday': Person.birthday,
        'age': case([(
            Person.birthday != None,
            func.date_part('year', func.age(Person.birthday))
        )]),
        'skype': _subq_contacts.c.skype,
        'phone': _subq_contacts.c.phone,
        'email': _subq_contacts.c.email,
        'citizen_passport': _subq_passports.c.citizen,
        'foreign_passport': _subq_passports.c.foreign,
    }

    _simple_search_fields = [
        Person.name,
        Person.first_name,
        Person.last_name,
        _subq_contacts.c.phone,
        _subq_contacts.c.email,
        _subq_contacts.c.skype,
        _subq_passports.c.citizen,
        _subq_passports.c.foreign,
    ]

    def __init__(self, context):
        super(PersonsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
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
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Person.id.in_(id))
