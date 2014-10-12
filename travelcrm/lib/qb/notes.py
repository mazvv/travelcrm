# -*coding: utf-8-*-

from collections import (
    OrderedDict,
    Iterable
)

from sqlalchemy.orm import class_mapper
from sqlalchemy.orm.properties import RelationshipProperty

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.note import Note


class NotesQueryBuilder(ResourcesQueryBuilder):

    _fields = OrderedDict({
        'id': Note.id,
        '_id': Note.id,
        'title': Note.title,
    })

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

    def filter_reference(self, ref_name, ref_id):
        for item in class_mapper(Note).iterate_properties:
            if isinstance(item, RelationshipProperty) and item.key == ref_name:
                ref_cls = item.mapper.class_
                self.query = (
                    self.query
                    .join(ref_cls, getattr(Note, ref_name))
                    .filter(ref_cls.id == ref_id)
                )
                return
        raise ValueError(
            u"Can't find given ref_name %{ref_name}".format(ref_name)
        )

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Note.id.in_(id))
