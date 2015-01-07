# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.touroperator import Touroperator
from ...models.subaccount import Subaccount

from ...lib.factories import SubaccountFactory



class TouroperatorSubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Touroperator.id.label('id'),
                Touroperator.name.label('title'),
                Subaccount.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Touroperator.resource)
            .join(Subaccount, Touroperator.subaccounts)
        )
        return query

    @classmethod
    def get_source_resource(cls, id):
        touroperator = Touroperator.get(id)
        return touroperator.resource

    @classmethod
    def bind_subaccount(cls, resource_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        touroperator = (
            DBSession.query(Touroperator)
            .filter(Touroperator.resource_id == resource_id)
            .first()
        )
        touroperator.subaccounts.append(subaccount)
        return touroperator
