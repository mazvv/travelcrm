# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.country import Country
from ..lib.utils.common_utils import translate as _

from travelcrm.forms.country import (
    CountryForm, 
    CountrySearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.country.CountryResource',
)
class CountryView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/country/index.mak',
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
        renderer='travelcrm:templates/country/form.mak',
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
            'title': _(u"View Country"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/country/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Country')}

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
        renderer='travelcrm:templates/country/form.mak',
        permission='edit'
    )
    def edit(self):
        country = Country.get(self.request.params.get('id'))
        return {'item': country, 'title': _(u'Edit Country')}

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
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/country/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Countries'),
            'rid': self.request.params.get('rid')
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
            item = Country.get(id)
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
