# -*-coding: utf-8-*-

from abc import ABCMeta


class SubaccountFactory(object):
    __metaclass__ = ABCMeta

    @classmethod
    def query_list(cls):
        raise NotImplemented()

    @classmethod
    def bind_subaccount(cls, source_id, subaccount):
        raise NotImplemented()


class SMSGatewayFactory(object):
    __metaclass__ = ABCMeta

    @classmethod
    def check_balance(cls):
        raise NotImplemented()

    @classmethod
    def send_message(cls, person_id, message):
        raise NotImplemented()
