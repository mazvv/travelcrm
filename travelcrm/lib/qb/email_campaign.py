# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.email_campaign import EmailCampaign


class EmailCampaignQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(EmailCampaignQueryBuilder, self).__init__(context)
        self._fields = {
            'id': EmailCampaign.id,
            '_id': EmailCampaign.id,
            'name': EmailCampaign.name,
            'subject': EmailCampaign.subject,
            'start_dt': EmailCampaign.start_dt,
        }
        self._simple_search_fields = [
            EmailCampaign.name,
            EmailCampaign.subject
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(EmailCampaign, Resource.email_campaign)
        super(EmailCampaignQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(EmailCampaign.id.in_(id))
