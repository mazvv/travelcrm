# -*coding: utf-8-*-
from collections import Iterable

from sqlalchemy import func, cast, Date, case

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
        'closed': Task.closed,
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

    def filter_date(self, date):
        if date:
            self.query = self.query.filter(cast(Task.deadline, Date) == date)

    def calendar_query(self, start_date, end_date=None):
        if start_date:
            self.query = self.query.filter(Task.deadline >= start_date)
        if end_date:
            self.query = self.query.filter(Task.deadline <= end_date)
        self.query = (
            self.query.with_entities(
                func.sum(case([(Task.closed == True, 1)], else_=0))
                    .label('closed'),
                func.sum(case([(Task.closed == False, 1)], else_=0))
                    .label('open'),
                func.to_char(cast(Task.deadline, Date), 'YYYYMMDD')
                    .label('deadline')
            )
            .group_by(cast(Task.deadline, Date))
        )
