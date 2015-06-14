# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.company import Company
from ...models.subaccount import Subaccount

from ...lib.factories import SubaccountFactory



class CompanySubaccountFactory(SubaccountFactory):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Company.id.label('id'),
                Company.name.label('title'),
                Company.name.label('name'),
                Subaccount.id.label('subaccount_id'),
            )
            .join(Resource, Company.resource)
            .join(Subaccount, Company.subaccounts)
        )
        return query

    @classmethod
    def get_source_resource(cls, id):
        company = Company.get(id)
        return company.resource

    @classmethod
    def bind_subaccount(cls, resource_id, subaccount):
        assert isinstance(subaccount, Subaccount)
        company = (
            DBSession.query(Company)
            .filter(Company.resource_id == resource_id)
            .first()
        )
        company.subaccounts.append(subaccount)
        return company
