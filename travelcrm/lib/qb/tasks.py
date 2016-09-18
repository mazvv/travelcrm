# -*coding: utf-8-*-

from collections import Iterable

from ...lib.helpers import text

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.task import Task


class _TitleSerializer():
    CHARACTERS_LIMIT = 26

    def __call__(self, name, row):
        return text.truncate(row.title, self.CHARACTERS_LIMIT)


class TasksQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TasksQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Task.id,
            '_id': Task.id,
            'title': Task.title,
            'deadline': Task.deadline,
            'status': Task.status,
        }
        self.build_query()
        self._serializers = {
            'title': _TitleSerializer()
        }

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Task, Resource.task)
        super(TasksQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Task.id.in_(id))

    def advanced_search(self, **kwargs):
        super(TasksQueryBuilder, self).advanced_search(**kwargs)
        if 'status' in kwargs:
            self._filter_status(kwargs.get('status'))

    def _filter_status(self, status):
        if status:
            self.query = self.query.filter(Task.status == status)
