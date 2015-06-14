# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.bank import Bank
from ..lib.utils.common_utils import translate as _

from ..forms.banks import (
    BankForm, 
    BankSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.banks.BanksResource',
)
class BanksView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/banks/index.mako',
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
        form = BankSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/banks/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            bank = Bank.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': bank.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Bank"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/banks/form.mako',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Bank')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = BankForm(self.request)
        if form.validate():
            bank = form.submit()
            DBSession.add(bank)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bank.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/banks/form.mako',
        permission='edit'
    )
    def edit(self):
        bank = Bank.get(self.request.params.get('id'))
        return {'item': bank, 'title': _(u'Edit Bank')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        bank = Bank.get(self.request.params.get('id'))
        form = BankForm(self.request)
        if form.validate():
            form.submit(bank)
            return {
                'success_message': _(u'Saved'),
                'response': bank.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/banks/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Banks'),
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
                    DBSession.query(Bank)
                    .filter(Bank.id.in_(ids))
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
