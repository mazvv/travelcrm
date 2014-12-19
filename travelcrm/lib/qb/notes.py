# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.note import Note


class NotesQueryBuilder(ResourcesQueryBuilder):

    _fields = {
        'id': Note.id,
        '_id': Note.id,
        'title': Note.title,
    }

    def __init__(self, context):
        super(NotesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = (
            self.query
            .join(Note, Resource.note)
        )
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Note.id.in_(id))
