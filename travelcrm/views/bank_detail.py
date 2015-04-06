# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.bank_detail import BankDetail
from ..lib.utils.common_utils import translate as _

from ..forms.bank_detail import (
    BankDetailForm,
    BankDetailSearchForm,
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.bank_detail.BankDetailResource',
)
class BankDetailView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/bank_detail/index.mak',
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
    def _list(self):
        form = BankDetailSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/bank_detail/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            bank_detail = BankDetail.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': bank_detail.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Bank Detail"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/bank_detail/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Bank Detail'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = BankDetailForm(self.request)
        if form.validate():
            bank_detail = form.submit()
            DBSession.add(bank_detail)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bank_detail.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/bank_detail/form.mak',
        permission='edit'
    )
    def edit(self):
        bank_detail = BankDetail.get(self.request.params.get('id'))
        return {
            'item': bank_detail,
            'title': _(u'Edit Bank Detail'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        bank_detail = BankDetail.get(self.request.params.get('id'))
        form = BankDetailForm(self.request)
        if form.validate():
            form.submit(bank_detail)
            return {
                'success_message': _(u'Saved'),
                'response': bank_detail.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/bank_detail/details.mak',
        permission='view'
    )
    def details(self):
        bank_detail = BankDetail.get(self.request.params.get('id'))
        return {
            'item': bank_detail,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/bank_detail/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Banks Details'),
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
            item = BankDetail.get(id)
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
