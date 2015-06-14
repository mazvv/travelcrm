# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.contact import Contact
from ..lib.utils.common_utils import translate as _

from ..forms.contacts import (
    ContactForm,
    ContactSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.contacts.ContactsResource',
)
class ContactsView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/contacts/index.mako',
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
        form = ContactSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            contact = Contact.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': contact.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Contact"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Contact'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = ContactForm(self.request)
        if form.validate():
            contact = form.submit()
            DBSession.add(contact)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': contact.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='edit'
    )
    def edit(self):
        contact = Contact.get(self.request.params.get('id'))
        return {
            'item': contact,
            'title': _(u'Edit Contact'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        contact = Contact.get(self.request.params.get('id'))
        form = ContactForm(self.request)
        if form.validate():
            form.submit(contact)
            return {
                'success_message': _(u'Saved'),
                'response': contact.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='add'
    )
    def copy(self):
        contact = Contact.get(self.request.params.get('id'))
        return {
            'item': contact,
            'title': _(u"Copy Contact")
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
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/contacts/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Contacts'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        ids = self.request.params.getall('id')
        if ids:
            try:
                (
                    DBSession.query(Contact)
                    .filter(Contact.id.in_(ids))
                    .delete()
                )
            except:
                DBSession.rollback()
                return {
                    'error_message': _(
                        u'Some objects could not be delete'
                    ),
                }
        return {'success_message': _(u'Deleted')}
