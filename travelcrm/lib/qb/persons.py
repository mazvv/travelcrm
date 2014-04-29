# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, case

from . import ResourcesQueryBuilder

from ...models import DBSession
from ...models.resource import Resource
from ...models.person import Person
from ...models.contact import Contact
from ...models.passport import Passport


class PersonsQueryBuilder(ResourcesQueryBuilder):
    _subq = (
        DBSession.query(
            Person.id.label('person_id'),
            func.array_to_string(
                func.array_agg(
                    case([(Contact.contact_type == 'phone', Contact.contact)])
                ),
                ', '
            ).label('phone'),
            func.array_to_string(
                func.array_agg(
                    case([(Contact.contact_type == 'email', Contact.contact)])
                ),
                ', '
            ).label('email'),
            func.array_to_string(
                func.array_agg(
                    case([(Contact.contact_type == 'skype', Contact.contact)])
                ),
                ', '
            ).label('skype'),
        )
        .join(Contact, Person.contacts)
        .join(Passport, Person.passports)
        .group_by(Person.id)
        .subquery()
    )

    _fields = {
        'id': Person.id,
        '_id': Person.id,
        'name': Person.name,
        'birthday': Person.birthday,
        'age': case([(
            Person.birthday != None,
            func.date_part('year', func.age(Person.birthday))
        )]),
        'skype': _subq.c.skype,
        'phone': _subq.c.phone,
        'email': _subq.c.email,
    }

    _simple_search_fields = [
        Person.name,
        Person.first_name,
        Person.last_name,
        _subq.c.phone,
        _subq.c.email,
        _subq.c.skype,
    ]

    def __init__(self, context):
        super(PersonsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Person, Resource.person)
            .outerjoin(self._subq, Person.id == self._subq.c.person_id)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Person.id.in_(id))
