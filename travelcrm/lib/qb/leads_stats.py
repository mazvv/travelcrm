# -*coding: utf-8-*-

from datetime import datetime, timedelta

from sqlalchemy import func

from ...models.resource import Resource
from ...models.lead import Lead 
from ...lib.qb import ResourcesQueryBuilder


class LeadsStatsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(LeadsStatsQueryBuilder, self).__init__(context)
        
        self._fields = {
            'date': Lead.lead_date,
            'quan': func.count(Lead.id),
        }
        self.build_query()


    def build_query(self):
        self.build_base_query()
        self.query = (
            self.query
            .join(Lead, Resource.lead)
            .group_by(Lead.lead_date)
        )
        super(LeadsStatsQueryBuilder, self).build_query()
        self.query = self.query.with_entities(
            Lead.lead_date, func.count(Lead.id).label('quan')
        )

    def advanced_search(self, **kwargs):
        super(LeadsStatsQueryBuilder, self).advanced_search(**kwargs)
        if 'period' in kwargs:
            self._filter_lead_period(
                kwargs.get('period')
            )
    
    def _filter_lead_period(self, period):
        if period:
            dt = datetime.today() - timedelta(days=period)
            self.query = self.query.filter(
                Lead.lead_date >= dt
            )
