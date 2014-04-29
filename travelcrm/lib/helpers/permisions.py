# -*-coding: utf-8-*-

from ...resources.persons import Persons
from ...resources.bpersons import BPersons


def get_persons_permisions(request):
    return Persons.get_permisions(Persons, request)


def get_bpersons_permisions(request):
    return BPersons.get_permisions(BPersons, request)
