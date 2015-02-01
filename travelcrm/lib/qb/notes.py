# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.note import Note


class NotesQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(NotesQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Note.id,
            '_id': Note.id,
            'title': Note.title,
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Note, Resource.note)
        super(NotesQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Note.id.in_(id))
