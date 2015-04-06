# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.general_service import GeneralService
from ..lib.utils.common_utils import translate as _
from ..forms.general_service import GeneralServiceSchema


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.general_service.GeneralServiceResource',
)
class GeneralServiceView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/services_items/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            general_service = GeneralService.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': general_service.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Service Item"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/services_items/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Service'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = GeneralServiceSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            general_service = GeneralService(
                service_id=controls.get('service_id'),
                touroperator_id=controls.get('touroperator_id'),
                currency_id=controls.get('currency_id'),
                price=controls.get('price'),
                person_id=controls.get('person_id'),
                resource=self.context.create_resource()
            )
            DBSession.add(general_service)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': general_service.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/services_items/form.mak',
        permission='edit'
    )
    def edit(self):
        general_service = GeneralService.get(self.request.params.get('id'))
        return {
            'item': general_service,
            'title': _(u'Edit Service'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = GeneralServiceSchema().bind(request=self.request)
        general_service = GeneralService.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            general_service.service_id = controls.get('service_id')
            general_service.touroperator_id = controls.get('touroperator_id')
            general_service.currency_id = controls.get('currency_id')
            general_service.price = controls.get('price')
            general_service.person_id = controls.get('person_id')
            return {
                'success_message': _(u'Saved'),
                'response': general_service.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/services_items/form.mak',
        permission='add'
    )
    def copy(self):
        general_service = GeneralService.get(self.request.params.get('id'))
        return {
            'item': general_service,
            'title': _(u"Copy Service")
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
        renderer='travelcrm:templates/services_items/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Services Items'),
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
            item = GeneralService.get(id)
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
