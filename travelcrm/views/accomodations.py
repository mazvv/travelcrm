# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.accomodation import Accomodation
from ..lib.qb.accomodations import AccomodationsQueryBuilder

from ..forms.accomodations import AccomodationSchema


log = logging.getLogger(__name__)


class Accomodations(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.accomodations.Accomodations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = AccomodationsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
            status=self.request.params.get('status'),
        )
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
        name='add',
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {'title': _(u'Add Hotel Category')}

    @view_config(
        name='add',
        context='..resources.accomodations.Accomodations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = AccomodationSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            accomodation = Accomodation(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(accomodation)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': accomodation.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        accomodation = Accomodation.get(self.request.params.get('id'))
        return {'item': accomodation, 'title': _(u'Edit Hotel Category')}

    @view_config(
        name='edit',
        context='..resources.accomodations.Accomodations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = AccomodationSchema().bind(request=self.request)
        accomodation = Accomodation.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            accomodation.name = controls.get('name')
            accomodation.resource.status = controls.get('status')
            return {
                'success_message': _(u'Saved'),
                'response': accomodation.id,
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.accomodations.Accomodations',
        request_method='GET',
        renderer='travelcrm:templates/accomodations/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.accomodations.Accomodations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            accomodation = Accomodation.get(id)
            if accomodation:
                DBSession.delete(accomodation)
        return {'success_message': _(u'Deleted')}
