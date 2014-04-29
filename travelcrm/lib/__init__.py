# -*-coding: utf-8-*-

from collections import Iterable

from sqlalchemy import TypeDecorator, SmallInteger


class EnumIntType(TypeDecorator):

    impl = SmallInteger

    values = None

    def __init__(self, values=None):
        super(EnumIntType, self).__init__()
        assert values is None or isinstance(values, Iterable), \
            u'Values must be None or iterable'
        self.values = values

    def process_bind_param(self, value, dialect):
        if value is None:
            return None
        values = map(lambda x: x[0], self.values)
        return values.index(value)

    def process_result_value(self, value, dialect):
        return None if value == None else self.values[value][1]
