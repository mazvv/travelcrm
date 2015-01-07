# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.person import Person
from ...models.subaccount import Subaccount
from ...lib.factories import SubaccountFactory


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
