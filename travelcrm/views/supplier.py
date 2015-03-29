# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.resource import Resource
from ..models.supplier import Supplier
from ..lib.utils.common_utils import translate as _
from ..lib.helpers.fields import suppliers_combobox_field
from ..forms.supplier import (
    SupplierForm, 
    SupplierSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.supplier.SupplierResource',
)
class SupplierView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/suppliers/index.mak',
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
        form = SupplierSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/suppliers/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            supplier = Supplier.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': supplier.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Supplier"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/suppliers/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Supplier'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = SupplierForm(self.request)
        if form.validate():
            supplier = form.submit()
            DBSession.add(supplier)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': supplier.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/suppliers/form.mak',
        permission='edit'
    )
    def edit(self):
        supplier = Supplier.get(self.request.params.get('id'))
        return {
            'item': supplier,
            'title': _(u'Edit Supplier'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        supplier = Supplier.get(self.request.params.get('id'))
        form = SupplierForm(self.request)
        if form.validate():
            form.submit(supplier)
            return {
                'success_message': _(u'Saved'),
                'response': supplier.id,
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/suppliers/details.mak',
        permission='view'
    )
    def details(self):
        supplier = Supplier.get(self.request.params.get('id'))
        return {
            'item': supplier,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/suppliers/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Suppliers'),
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
            item = Supplier.get(id)
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
        name='combobox',
        request_method='POST',
        permission='view'
    )
    def _combobox(self):
        value = None
        resource = Resource.get(self.request.params.get('resource_id'))
        if resource:
            value = resource.supplier.id
        return Response(
            suppliers_combobox_field(
                self.request, value, name=self.request.params.get('name')
            )
        )
