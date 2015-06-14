# -*-coding: utf-8-*-

from ...resources.persons import PersonsResource
from ...resources.bpersons import BPersonsResource
from ...resources.accounts import AccountsResource
from ...resources.orders_items import OrdersItemsResource


def get_persons_permisions(request):
    return PersonsResource.get_permisions(PersonsResource, request)


def get_bpersons_permisions(request):
    return BPersonsResource.get_permisions(BPersonsResource, request)


def get_accounts_permisions(request):
    return AccountsResource.get_permisions(AccountsResource, request)


def get_orders_items_permisions(request):
    return OrdersItemsResource.get_permisions(OrdersItemsResource, request)
