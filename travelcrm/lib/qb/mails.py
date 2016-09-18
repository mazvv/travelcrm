# -*coding: utf-8-*-
from collections import Iterable

from . import ResourcesQueryBuilder
from ...models.resource import Resource
from ...models.mail import Mail


class MailsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(MailsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Mail.id,
            '_id': Mail.id,
            'name': Mail.name,
            'subject': Mail.subject,
        }
        self._simple_search_fields = [
            Mail.name, Mail.subject
        ]
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Mail, Resource.mail)
        super(MailsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Mail.id.in_(id))
