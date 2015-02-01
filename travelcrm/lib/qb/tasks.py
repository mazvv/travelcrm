# -*coding: utf-8-*-
import datetime
from collections import Iterable

from sqlalchemy import func, cast, Date, Time, case

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.task import Task
from ...lib.utils.common_utils import cast_int


class TasksQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(TasksQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Task.id,
            '_id': Task.id,
            'title': Task.title,
            'time': cast(Task.deadline, Time),
            'closed': Task.closed,
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

    def advanced_search(self, **kwargs):
        super(TasksQueryBuilder, self).advanced_search(**kwargs)
        if 'y' in kwargs and 'm' in kwargs and 'd' in kwargs:
            self._filter_date(
                kwargs.get('y'), kwargs.get('m'), kwargs.get('d')
            )
        if 'closed' in kwargs:
            self._filter_closed(kwargs.get('closed'))

    def _filter_date(self, y, m, d):
        if y and m and d:
            date = datetime.date(cast_int(y), cast_int(m), cast_int(d))
            self.query = self.query.filter(cast(Task.deadline, Date) == date)

    def _filter_closed(self, closed):
        if closed:
            closed = bool(cast_int(closed))
            self.query = self.query.filter(Task.closed == closed)
