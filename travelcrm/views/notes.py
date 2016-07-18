# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.note import Note
from ..lib.utils.resources_utils import get_resource_class
from ..lib.utils.common_utils import translate as _

from ..forms.notes import (
    NoteForm,
    NoteSearchForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.notes.NotesResource',
)
class NotesView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/notes/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

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
        renderer='travelcrm:templates/notes/form.mako',
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
            'title': self._get_title(_(u'View')),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/notes/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': self._get_title(_(u'Add')),
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
        renderer='travelcrm:templates/notes/form.mako',
        permission='edit'
    )
    def edit(self):
        note = Note.get(self.request.params.get('id'))
        return {
            'item': note,
            'title': self._get_title(_(u'Edit')),
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
        renderer='travelcrm:templates/notes/form.mako',
        permission='add'
    )
    def copy(self):
        note = Note.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': note,
            'title': self._get_title(_(u'Copy')),
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
        renderer='travelcrm:templates/notes/details.mako',
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
        renderer='travelcrm:templates/notes/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                items = DBSession.query(Note).filter(
                    Note.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                DBSession.flush()
            except:
                errors=True
                DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
