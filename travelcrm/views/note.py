# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.note import Note
from ..lib.utils.resources_utils import get_resource_class
from ..lib.utils.common_utils import translate as _

from ..forms.note import (
    NoteForm,
    NoteSearchForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.note.NoteResource',
)
class NoteView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/note/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        form = NoteSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/note/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            note = Note.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': note.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Note"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/note/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Note'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = NoteForm(self.request)
        if form.validate():
            note = form.submit()
            DBSession.add(note)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': note.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/note/form.mak',
        permission='edit'
    )
    def edit(self):
        note = Note.get(self.request.params.get('id'))
        return {
            'item': note,
            'title': _(u'Edit Note'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        note = Note.get(self.request.params.get('id'))
        form = NoteForm(self.request)
        if form.validate():
            form.submit(note)
            return {
                'success_message': _(u'Saved'),
                'response': note.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/note/form.mak',
        permission='add'
    )
    def copy(self):
        note = Note.get(self.request.params.get('id'))
        return {
            'item': note,
            'title': _(u"Copy Note")
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/note/details.mak',
        permission='view'
    )
    def details(self):
        note = Note.get(self.request.params.get('id'))
        note_resource = None
        if note.note_resource:
            resource_cls = get_resource_class(
                note.note_resource.resource_type.name
            )
            note_resource = resource_cls(self.request)
        return {
            'item': note,
            'note_resource': note_resource,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/note/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Notes'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Note.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
