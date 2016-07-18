# -*coding: utf-8-*-

from ...interfaces import ISubaccountFactory

from ...models import DBSession
from ...models.resource import Resource
from ...models.account import Account
from ...models.subaccount import Subaccount

from ...lib.utils.resources_utils import get_resources_types_by_interface
from ...lib.bl.factories import get_subaccounts_factories_resources_types
from ...lib.utils.resources_utils import get_resource_class
from ...lib.utils.sql_utils import build_union_query
from ...lib.bl.employees import get_employee_structure


def get_subaccounts_types():
    return get_resources_types_by_interface(ISubaccountFactory)


def query_resource_data():
    factories = get_subaccounts_factories_resources_types()
    queries = [factory.query_list() for factory in factories]
    return build_union_query(queries)


def get_bound_resource_by_subaccount_id(subaccount_id):
    bound_resource = (
        query_resource_data()
        .filter(Subaccount.id == subaccount_id)
        .first()
    )
    return Resource.get(bound_resource.resource_id)


def get_factory_by_subaccount_id(subaccount_id):
    resource = get_bound_resource_by_subaccount_id(subaccount_id)
    source_cls = get_resource_class(resource.resource_type.name)
    factory = source_cls.get_subaccount_factory()
    return factory


def get_subaccount_by_source_id(id, resource_type_id, account_id):
    subq = query_resource_data().subquery()
    return (
        DBSession.query(Subaccount)
        .select_from(subq)
        .join(Resource, Resource.id == subq.c.resource_id)
        .join(Subaccount, Subaccount.id == subq.c.subaccount_id)
        .filter(
            subq.c.id == id,
            Subaccount.account_id == account_id,
            Resource.resource_type_id == resource_type_id
        )
        .first()
    )


def get_subaccount_by_source_resource_id(resource_id, account_id):
    subq = query_resource_data().subquery()
    return (
        DBSession.query(Subaccount)
        .select_from(subq)
        .join(Resource, Resource.id == subq.c.resource_id)
        .join(Subaccount, Subaccount.id == subq.c.subaccount_id)
        .filter(
            subq.c.resource_id == resource_id,
            Subaccount.account_id == account_id,
        )
        .first()
    )


def generate_subaccount_name(name, account_id):
    account = Account.get(account_id)
    return "%s, %s, %s" % (
        name, account.currency.iso_code, account.account_type.title
    )


def get_company_subaccount(account_id):
    account = Account.get(account_id)
    maintainer_structure = get_employee_structure(
        account.resource.maintainer
    )
    return get_subaccount_by_source_resource_id(
        maintainer_structure.company.resource.id, account_id,
    )


def get_subaccount_copy(subaccount_id, request):
    contract = Contract.get(contract_id)
    supplier = contract.supplier

    commissions = []
    for commission in list(contract.commissions):
        commission = Commission.get_copy(commission.id)
        resource = CommissionsResource.create_resource(
            get_auth_employee(request)
        )        
        DBSession.add(resource)
        DBSession.flush([resource,])
        commission.resource = resource
        commissions.append(commission)
    DBSession.add_all(commissions)
    DBSession.flush(commissions)

    contract = Contract.get_copy(contract.id)
    if not contract:
        return

    contract.supplier = supplier
    contract.commissions = commissions
    return contract
