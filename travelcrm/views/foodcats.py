# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.foodcat import Foodcat
from ..lib.qb.foodcats import FoodcatsQueryBuilder

from ..forms.foodcats import FoodcatSchema


log = logging.getLogger(__name__)


class Foodcats(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.foodcats.Foodcats',
        request_method='GET',
        renderer='travelcrm:templates/foodcats/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.foodcats.Foodcats',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = FoodcatsQueryBuilder(self.context)
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
        context='..resources.foodcats.Foodcats',
        request_method='GET',
        renderer='travelcrm:templates/foodcats/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {'title': _(u'Add Hotel Category')}

    @view_config(
        name='add',
        context='..resources.foodcats.Foodcats',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = FoodcatSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            foodcat = Foodcat(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(foodcat)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.foodcats.Foodcats',
        request_method='GET',
        renderer='travelcrm:templates/foodcats/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        foodcat = Foodcat.get(self.request.params.get('id'))
        return {'item': foodcat, 'title': _(u'Edit Hotel Category')}

    @view_config(
        name='edit',
        context='..resources.foodcats.Foodcats',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = FoodcatSchema().bind(request=self.request)
        foodcat = Foodcat.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            foodcat.name = controls.get('name')
            foodcat.resource.status = controls.get('status')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.foodcats.Foodcats',
        request_method='GET',
        renderer='travelcrm:templates/foodcats/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.foodcats.Foodcats',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            foodcat = Foodcat.get(id)
            if foodcat:
                DBSession.delete(foodcat)
        return {'success_message': _(u'Deleted')}
