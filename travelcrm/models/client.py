# -*-coding: utf-8-*-

from ..models.person import Person


class Client(Person):
    __mapper_args__ = {'polymorphic_identity': 'client'}
