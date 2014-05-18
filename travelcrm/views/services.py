# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.service import Service
from ..lib.qb.services import ServicesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.services import ServiceSchema


log = logging.getLogger(__name__)


class Services(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.services.Services',
        request_method='GET',
        renderer='travelcrm:templates/services/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.services.Services',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = ServicesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
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
        context='..resources.services.Services',
        request_method='GET',
        renderer='travelcrm:templates/services/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Service')}

    @view_config(
        name='add',
        context='..resources.services.Services',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = ServiceSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            service = Service(
                name=controls.get('name'),
                descr=controls.get('descr'),
                resource=self.context.create_resource()
            )
            DBSession.add(service)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': service.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.services.Services',
        request_method='GET',
        renderer='travelcrm:templates/services/form.mak',
        permission='edit'
    )
    def edit(self):
        service = Service.get(self.request.params.get('id'))
        return {'item': service, 'title': _(u'Edit Service')}

    @view_config(
        name='edit',
        context='..resources.services.Services',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = ServiceSchema().bind(request=self.request)
        service = Service.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            service.name = controls.get('name')
            service.descr = controls.get('descr')
            return {
                'success_message': _(u'Saved'),
                'response': service.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.services.Services',
        request_method='GET',
        renderer='travelcrm:templates/services/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.services.Services',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            service = Service.get(id)
            if service:
                DBSession.delete(service)
        return {'success_message': _(u'Deleted')}
