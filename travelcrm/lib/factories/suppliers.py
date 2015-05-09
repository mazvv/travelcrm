# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.supplier import Supplier
from ...models.subaccount import Subaccount

from ...lib.factories import SubaccountFactory



class SupplierSubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Supplier.id.label('id'),
                Supplier.name.label('title'),
                Subaccount.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Supplier.resource)
            .join(Subaccount, Supplier.subaccounts)
        )
        return query

    @classmethod
    def get_source_resource(cls, id):
        supplier = Supplier.get(id)
        return supplier.resource

    @classmethod
    def bind_subaccount(cls, resource_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        supplier = (
            DBSession.query(Supplier)
            .filter(Supplier.resource_id == resource_id)
            .first()
        )
        supplier.subaccounts.append(subaccount)
        return supplier
