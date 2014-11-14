# -*coding: utf-8-*-

from sqlalchemy import func, case

from ...models import DBSession
from ...models.resource import Resource
from ...models.person import Person
from ...models.contact import Contact
from ...models.passport import Passport
from ...models.subaccount import Subaccount
from ...lib.bl import SubaccountFactory


def query_person_contacts():
    return (
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
        .group_by(Person.id)
    )


def query_person_passports():
    return (
        DBSession.query(
            Person.id.label('person_id'),
            func.array_to_string(
                func.array_agg(
                    case([(Passport.passport_type == 'citizen', Passport.num)])
                ),
                ', '
            ).label('citizen'),
            func.array_to_string(
                func.array_agg(
                    case([(Passport.passport_type == 'foreign', Passport.num)])
                ),
                ', '
            ).label('foreign'),
        )
        .join(Passport, Person.passports)
        .group_by(Person.id)
    )


class PersonSubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Person.id.label('id'),
                Person.name.label('title'),
                Subaccount.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Person.resource)
            .join(Subaccount, Person.subaccounts)
        )
        return query

    @classmethod
    def get_source_resource(cls, id):
        person = Person.get(id)
        return person.resource

    @classmethod
    def bind_subaccount(cls, resource_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        person = (
            DBSession.query(Person)
            .filter(Person.resource_id == resource_id)
            .first()
        )
        person.subaccounts.append(subaccount)
        return person
