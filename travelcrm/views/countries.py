# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.country import Country
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.countries import CountriesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.countries import (
    CountrySchema, 
    CountrySearchSchema
)


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
        schema = CountrySearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = CountriesQueryBuilder(self.context)
        qb.search_simple(controls.get('q'))
        qb.advanced_search(**controls)
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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
        name='view',
        context='..resources.countries.Countries',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mak',
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
        context='..resources.countries.Countries',
        request_method='GET',
        renderer='travelcrm:templates/countries/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Country')}

    @view_config(
        name='add',
        context='..resources.countries.Countries',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = CountrySchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            country = Country(
                iso_code=controls.get('iso_code'),
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                country.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                country.resource.tasks.append(task)
            DBSession.add(country)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': country.id
            }
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
        schema = CountrySchema().bind(request=self.request)
        country = Country.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            country.iso_code = controls.get('iso_code')
            country.name = controls.get('name')
            country.resource.notes = []
            country.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                country.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                country.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': country.id
            }
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
            'title': _(u'Delete Countries'),
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
