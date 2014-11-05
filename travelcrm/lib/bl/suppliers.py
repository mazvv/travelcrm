# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.supplier import Supplier
from ...models.subaccount import Subaccount

from ...lib.bl import SubaccountFactory


class SupplierSubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Supplier.name.label('title'),
                Subaccount.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Supplier.resource)
            .join(Subaccount, Supplier.subaccount)
        )
        return query

    @classmethod
    def bind_subaccount(cls, supplier_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        supplier = Supplier.get(supplier_id)
        supplier.subaccount = subaccount
        return supplier
