# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.currency_rate import CurrencyRate
from ..lib.utils.common_utils import translate as _
from ..forms.currency_rate import (
    CurrencyRateForm, 
    CurrencyRateSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.currency_rate.CurrencyRateResource',
)
class CurrencyRateView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/currency_rate/index.mak',
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
        form = CurrencyRateSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/currency_rate/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            currency_rate = CurrencyRate.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': currency_rate.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Currency Rate"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/currency_rate/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Currency Rate')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = CurrencyRateForm(self.request)
        if form.validate():
            currency_rate = form.submit()
            DBSession.add(currency_rate)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': currency_rate.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/currency_rate/form.mak',
        permission='edit'
    )
    def edit(self):
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        return {'item': currency_rate, 'title': _(u'Edit Currency Rate')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        form = CurrencyRateForm(self.request)
        if form.validate():
            form.submit(currency_rate)
            return {
                'success_message': _(u'Saved'),
                'response': currency_rate.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/currency_rate/form.mak',
        permission='add'
    )
    def copy(self):
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        return {
            'item': currency_rate,
            'title': _(u"Copy Rate")
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
        renderer='travelcrm:templates/currency_rate/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Currencies Rates'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                (
                    DBSession.query(CurrencyRate)
                    .fiter(CurrencyRate.id.in_(ids))
                    .delete()
                )
            except:
                errors=True
                DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
