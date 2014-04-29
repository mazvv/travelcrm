# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.task import Task


class TasksQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Task.id,
        '_id': Task.id,
        'title': Task.title,
        'reminder': Task.reminder,
        'deadline': Task.deadline,
        'employee': Task.employee_id,
        'priority': Task.priority,
        'status': Task.status,
        'descr': Task.descr
    }

    def __init__(self, context):
        super(TasksQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Task, Resource.task)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Task.id.in_(id))
