# -*-coding: utf-8-*-

from ...resources.person import PersonResource
from ...resources.bperson import BPersonResource
from ...resources.account import AccountResource
from ...resources.order_item import OrderItemResource


def get_persons_permisions(request):
    return PersonResource.get_permisions(PersonResource, request)


def get_bpersons_permisions(request):
    return BPersonResource.get_permisions(BPersonResource, request)


def get_accounts_permisions(request):
    return AccountResource.get_permisions(AccountResource, request)


def get_orders_items_permisions(request):
    return OrderItemResource.get_permisions(OrderItemResource, request)
