# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.service_item import ServiceItem
from ..models.calculation import Calculation
from ..lib.qb.calculations import CalculationsQueryBuilder
from ..lib.utils.common_utils import translate as _

from travelcrm.forms.services_items import ServiceItemSchema


log = logging.getLogger(__name__)


class Calculations(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/index.mak',
        permission='view'
    )
    def index(self):
        resource_id = self.request.params.get('resource_id')
        return {
            'resource_id': resource_id
        }

    @view_config(
        name='list',
        context='..resources.calculations.Calculations',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = CalculationsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
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
        name='view',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Calculation"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/calculations/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Calculation'),
        }

    @view_config(
        name='add',
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = CalculationSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            service_item = Calculation(
                service_id=controls.get('service_id'),
                touroperator_id=controls.get('touroperator_id'),
                currency_id=controls.get('currency_id'),
                price=controls.get('price'),
                person_id=controls.get('person_id'),
                resource=self.context.create_resource()
            )
            DBSession.add(service_item)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': service_item.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/services_items/form.mak',
        permission='edit'
    )
    def edit(self):
        service_item = ServiceItem.get(self.request.params.get('id'))
        return {
            'item': service_item,
            'title': _(u'Edit Service'),
        }

    @view_config(
        name='edit',
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = ServiceItemSchema().bind(request=self.request)
        service_item = ServiceItem.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            service_item.service_id = controls.get('service_id')
            service_item.touroperator_id = controls.get('touroperator_id')
            service_item.currency_id = controls.get('currency_id')
            service_item.price = controls.get('price')
            service_item.person_id = controls.get('person_id')
            return {
                'success_message': _(u'Saved'),
                'response': service_item.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.calculations.Calculations',
        request_method='GET',
        renderer='travelcrm:templates/services_items/form.mak',
        permission='add'
    )
    def copy(self):
        service_item = ServiceItem.get(self.request.params.get('id'))
        return {
            'item': service_item,
            'title': _(u"Copy Service")
        }

    @view_config(
        name='copy',
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.calculations.Calculations',
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
        context='..resources.calculations.Calculations',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = ServiceItem.get(id)
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
