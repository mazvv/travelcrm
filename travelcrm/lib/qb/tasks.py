# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.task import Task


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
