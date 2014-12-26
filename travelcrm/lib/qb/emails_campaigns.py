# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.email_campaign import EmailCampaign


class EmailsCampaignsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': EmailCampaign.id,
        '_id': EmailCampaign.id,
        'name': EmailCampaign.name,
        'subject': EmailCampaign.subject,
        'start_dt': EmailCampaign.start_dt,
    }
    _simple_search_fields = [
        EmailCampaign.name,
        EmailCampaign.subject
    ]

    def __init__(self, context):
        super(EmailsCampaignsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(EmailCampaign, Resource.email_campaign)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(EmailCampaign.id.in_(id))
