# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.bperson import BPerson
from ..lib.utils.common_utils import translate as _
from ..forms.bpersons import (
    BPersonForm, 
    BPersonSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.bpersons.BPersonsResource',
)
class BPersonsView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/bpersons/index.mako',
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
    def list(self):
        form = BPersonSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            bperson = BPerson.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': bperson.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Business Person"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Business Person'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = BPersonForm(self.request)
        if form.validate():
            bperson = form.submit()
            DBSession.add(bperson)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bperson.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mako',
        permission='edit'
    )
    def edit(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
            'title': _(u'Edit Business Person'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        bperson = BPerson.get(self.request.params.get('id'))
        form = BPersonForm(self.request)
        if form.validate():
            form.submit(bperson)
            return {
                'success_message': _(u'Saved'),
                'response': bperson.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mako',
        permission='add'
    )
    def copy(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
            'title': _(u"Copy Business Person")
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
        renderer='travelcrm:templates/bpersons/details.mako',
        permission='view'
    )
    def details(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Business Persons'),
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
            item = BPerson.get(id)
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
