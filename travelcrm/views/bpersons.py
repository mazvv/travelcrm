# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.bperson import BPerson
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from ..forms.bpersons import (
    BPersonForm, 
    BPersonSearchForm,
    BPersonAssignForm,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.bpersons.BPersonsResource',
)
class BPersonsView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/bpersons/index.mako',
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
            'title': self._get_title(_(u'View')),
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
            'title': self._get_title(_(u'Add')),
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
            event = ResourceCreated(self.request, bperson)
            event.registry()
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
            'title': self._get_title(_(u'Edit')),
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
            event = ResourceCreated(self.request, bperson)
            event.registry()
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
        bperson = BPerson.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': bperson,
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
                items = DBSession.query(BPerson).filter(
                    BPerson.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                    event = ResourceCreated(self.request, item)
                    event.registry()
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

    @view_config(
        name='assign',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/assign.mako',
        permission='assign'
    )
    def assign(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Assign Maintainer')),
        }

    @view_config(
        name='assign',
        request_method='POST',
        renderer='json',
        permission='assign'
    )
    def _assign(self):
        form = BPersonAssignForm(self.request)
        if form.validate():
            form.submit(self.request.params.getall('id'))
            return {
                'success_message': _(u'Assigned'),
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='subscribe',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/subscribe.mako',
        permission='view'
    )
    def subscribe(self):
        return {
            'id': self.request.params.get('id'),
            'title': self._get_title(_(u'Subscribe')),
        }

    @view_config(
        name='subscribe',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _subscribe(self):
        ids = self.request.params.getall('id')
        for id in ids:
            bperson = BPerson.get(id)
            subscribe_resource(self.request, bperson.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
