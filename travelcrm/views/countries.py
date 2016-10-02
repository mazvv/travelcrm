# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.country import Country
from ..lib.bl.subscriptions import subscribe_resource
from ..lib.utils.common_utils import translate as _
from travelcrm.forms.countries import (
    CountryForm, 
    CountrySearchForm,
    CountryAssignForm,
)
from ..lib.events.resources import (
    ResourceCreated,
    ResourceChanged,
    ResourceDeleted,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.countries.CountriesResource',
)
class CountriesView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/countries/index.mako',
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
        form = CountrySearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            country = Country.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': country.id}
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
        renderer='travelcrm:templates/countries/form.mako',
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
        form = CountryForm(self.request)
        if form.validate():
            country = form.submit()
            DBSession.add(country)
            DBSession.flush()
            event = ResourceCreated(self.request, country)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': country.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mako',
        permission='edit'
    )
    def edit(self):
        country = Country.get(self.request.params.get('id'))
        return {
            'item': country, 
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        country = Country.get(self.request.params.get('id'))
        form = CountryForm(self.request)
        if form.validate():
            form.submit(country)
            event = ResourceChanged(self.request, country)
            event.registry()
            return {
                'success_message': _(u'Saved'),
                'response': country.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mako',
        permission='add'
    )
    def copy(self):
        country = Country.get_copy(self.request.params.get('id'))
        return {
            'action': self.request.path_url,
            'item': country,
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
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/countries/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'rid': self.request.params.get('rid')
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
                items = DBSession.query(Country).filter(
                    Country.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
                    event = ResourceDeleted(self.request, item)
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
        renderer='travelcrm:templates/countries/assign.mako',
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
        form = CountryAssignForm(self.request)
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
        renderer='travelcrm:templates/countries/subscribe.mako',
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
            country = Country.get(id)
            subscribe_resource(self.request, country.resource)
        return {
            'success_message': _(u'Subscribed'),
        }
