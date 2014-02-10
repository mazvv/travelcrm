# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.country import Country
from ..lib.qb.countries import CountriesQueryBuilder

from ..forms.countries import CountrySchema


log = logging.getLogger(__name__)


class Countries(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.countries.Countries',
        request_method='GET',
        renderer='travelcrm:templates/countries/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.countries.Countries',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = CountriesQueryBuilder(self.context)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add',
        context='..resources.countries.Countries',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {'title': _(u'Add Country')}

    @view_config(
        name='add',
        context='..resources.countries.Countries',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = CountrySchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            country = Country(
                iso_code=controls.get('iso_code'),
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(country)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.countries.Countries',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        country = Country.get(self.request.params.get('id'))
        return {'item': country, 'title': _(u'Edit Country')}

    @view_config(
        name='edit',
        context='..resources.countries.Countries',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = CountrySchema().bind(request=self.request)
        country = Country.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            country.iso_code = controls.get('iso_code')
            country.name = controls.get('name')
            country.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.countries.Countries',
        request_method='GET',
        renderer='travelcrm:templates/countries/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.countries.Countries',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            country = Country.get(id)
            if country:
                DBSession.delete(country)
        return {'success_message': _(u'Deleted')}
