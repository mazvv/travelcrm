# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.campaign import Campaign


class CampaignsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(CampaignsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Campaign.id,
            '_id': Campaign.id,
            'name': Campaign.name,
            'subject': Campaign.subject,
            'start_dt': Campaign.start_dt,
            'status': Campaign.status,
        }
        self._simple_search_fields = [
            Campaign.name,
            Campaign.subject
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Campaign, Resource.campaign)
        super(CampaignsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Campaign.id.in_(id))
