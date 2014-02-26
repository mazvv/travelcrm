# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.region import Region
from ..lib.qb.regions import RegionsQueryBuilder

from ..forms.regions import RegionSchema


log = logging.getLogger(__name__)


class Regions(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.regions.Regions',
        request_method='GET',
        renderer='travelcrm:templates/regions/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.regions.Regions',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = RegionsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('search'),
        )
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
        context='..resources.regions.Regions',
        request_method='GET',
        renderer='travelcrm:templates/regions/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {'title': _(u'Add Region')}

    @view_config(
        name='add',
        context='..resources.regions.Regions',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = RegionSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            region = Region(
                country_id=controls.get('country_id'),
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(region)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.regions.Regions',
        request_method='GET',
        renderer='travelcrm:templates/regions/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        region = Region.get(self.request.params.get('id'))
        return {'item': region, 'title': _(u'Edit Region')}

    @view_config(
        name='edit',
        context='..resources.regions.Regions',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = RegionSchema().bind(request=self.request)
        region = Region.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            region.country_id = controls.get('country_id')
            region.name = controls.get('name')
            region.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.regions.Regions',
        request_method='GET',
        renderer='travelcrm:templates/regions/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.regions.Regions',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            region = Region.get(id)
            if region:
                DBSession.delete(region)
        return {'success_message': _(u'Deleted')}
