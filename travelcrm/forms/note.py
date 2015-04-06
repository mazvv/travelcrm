# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm,
)
from ..resources.note import NoteResource
from ..models.note import Note
from ..lib.qb.note import NoteQueryBuilder


class _NoteSchema(ResourceSchema):
    title = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=255)
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
    )


class NoteForm(BaseForm):
    _schema = _NoteSchema

    def submit(self, note=None):
        context = NoteResource(self.request)
        if not note:
            note = Note(
                resource=context.create_resource()
            )
        note.title = self._controls.get('title')
        note.descr = self._controls.get('descr')
        return note


class NoteSearchForm(BaseSearchForm):
    _qb = NoteQueryBuilder
