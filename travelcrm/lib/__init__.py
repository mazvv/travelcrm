# -*-coding: utf-8-*-

from collections import Iterable

from sqlalchemy import TypeDecorator, SmallInteger


class EnumInt(object):
    def __init__(self, value, values):
        self.value = value
        self._values = values

    @property
    def title(self):
        return self.value if self.value is None else self._values[self.value][1]

    @property
    def key(self):
        return self.value is not None and self._values[self.value][0]

    def __eq__(self, other):
        values = map(lambda x: x[0], self._values)
        return (other in values) and self.value == values.index(other)

    def __str__(self):
        return self.value if self.value is None else u"%s, %s" % (
            self.value, self._values[self.value][1]
        )

    def __repr__(self):
        return u"EnumInt(%s)" % self

    def serialize(self):
        return {'key': self.key, 'value': self.value, 'title': self.title}


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
        return EnumInt(value, self.values)
