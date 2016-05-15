# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm,
)
from ..resources.notes import NotesResource
from ..models.note import Note
from ..models.upload import Upload
from ..lib.qb.notes import NotesQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _NoteSchema(ResourceSchema):
    title = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=255)
    )
    descr = colander.SchemaNode(
        colander.String(),
    )
    upload_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )

    def deserialize(self, cstruct):
        if (
            'upload_id' in cstruct
            and not isinstance(cstruct.get('upload_id'), list)
        ):
            val = cstruct['upload_id']
            cstruct['upload_id'] = list()
            cstruct['upload_id'].append(val)

        return super(_NoteSchema, self).deserialize(cstruct)


class NoteForm(BaseForm):
    _schema = _NoteSchema

    def submit(self, note=None):
        if not note:
            note = Note(
                resource=NotesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            note.uploads = []
        note.title = self._controls.get('title')
        note.descr = self._controls.get('descr')
        for id in self._controls.get('upload_id'):
            upload = Upload.get(id)
            note.uploads.append(upload)
        return note


class NoteSearchForm(BaseSearchForm):
    _qb = NotesQueryBuilder
