# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.service_sale import ServiceSale
from ..models.service_item import ServiceItem
from ..models.note import Note
from ..models.task import Task
from ..resources.invoice import InvoiceResource
from ..resources.calculation import CalculationResource
from ..lib.qb.service_sale import ServiceSaleQueryBuilder

from ..lib.bl.currencies_rates import currency_base_exchange
from ..lib.utils.common_utils import translate as _
from ..forms.service_sale import (
    ServiceSaleSchema, 
    ServiceSaleSearchSchema
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.service_sale.ServiceSaleResource',
)
class ServiceSaleView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/services_sales/index.mak',
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
        schema = ServiceSaleSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = ServiceSaleQueryBuilder(self.context)
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
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            service_sale = ServiceSale.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': service_sale.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Services Sale"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Service Sale'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = ServiceSaleSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            service_sale = ServiceSale(
                deal_date=controls.get('deal_date'),
                advsource_id=controls.get('advsource_id'),
                customer_id=controls.get('customer_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('service_item_id'):
                service_item = ServiceItem.get(id)
                service_item.base_price = currency_base_exchange(
                    service_item.price,
                    service_item.currency_id,
                    controls.get('deal_date'),
                )
                service_sale.services_items.append(service_item)
            for id in controls.get('note_id'):
                note = Note.get(id)
                service_sale.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                service_sale.resource.tasks.append(task)
            DBSession.add(service_sale)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': service_sale.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='edit'
    )
    def edit(self):
        sale_service = ServiceSale.get(self.request.params.get('id'))
        return {
            'item': sale_service,
            'title': _(u'Edit Service Sale'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = ServiceSaleSchema().bind(request=self.request)
        service_sale = ServiceSale.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            service_sale.deal_date = controls.get('deal_date')
            service_sale.advsource_id = controls.get('advsource_id')
            service_sale.customer_id = controls.get('customer_id')
            service_sale.services_items = []
            service_sale.resource.notes = []
            service_sale.resource.tasks = []
            for id in controls.get('service_item_id', []):
                service_item = ServiceItem.get(id)
                service_item.base_price = currency_base_exchange(
                    service_item.price,
                    service_item.currency_id,
                    controls.get('deal_date'),
                )
                service_sale.services_items.append(service_item)
            for id in controls.get('note_id'):
                note = Note.get(id)
                service_sale.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                service_sale.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': service_sale.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/form.mak',
        permission='add'
    )
    def copy(self):
        service_sale = ServiceSale.get(self.request.params.get('id'))
        return {
            'item': service_sale,
            'title': _(u"Copy Service Sale")
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
        renderer='travelcrm:templates/services_sales/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Services Sales'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/services_sales/details.mak',
        permission='view'
    )
    def details(self):
        service_sale = ServiceSale.get(self.request.params.get('id'))
        return {
            'item': service_sale,
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
            item = ServiceSale.get(id)
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

    @view_config(
        name='invoice',
        request_method='GET',
        permission='invoice'
    )
    def invoice(self):
        service_sale = ServiceSale.get(self.request.params.get('id'))
        if service_sale:
            return HTTPFound(
                self.request.resource_url(
                    InvoiceResource(self.request),
                    'add' if not service_sale.invoice else 'edit',
                    query=(
                        {'resource_id': service_sale.resource.id}
                        if not service_sale.invoice
                        else {'id': service_sale.invoice.id}
                    )
                )
            )

    @view_config(
        name='calculation',
        request_method='GET',
        permission='calculation'
    )
    def calculation(self):
        service_sale = ServiceSale.get(self.request.params.get('id'))
        if service_sale:
            return HTTPFound(
                self.request.resource_url(
                    CalculationResource(self.request),
                    query=(
                        {'resource_id': service_sale.resource.id}
                    )
                )
            )
