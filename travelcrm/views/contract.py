# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.contract import Contract
from ..lib.utils.common_utils import translate as _

from ..forms.contract import (
    ContractForm, 
    ContractSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.contract.ContractResource',
)
class ContractView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/contract/index.mak',
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
        form = ContractSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/contract/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            contract = Contract.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': contract.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Contract"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/contract/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Contract'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = ContractForm(self.request)
        if form.validate():
            contract = form.submit()
            DBSession.add(contract)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': contract.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/contract/form.mak',
        permission='edit'
    )
    def edit(self):
        contract = Contract.get(self.request.params.get('id'))
        return {
            'item': contract,
            'title': _(u'Edit Contract'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        contract = Contract.get(self.request.params.get('id'))
        form = ContractForm(self.request)
        if form.validate():
            return {
                'success_message': _(u'Saved'),
                'response': contract.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/contract/form.mak',
        permission='add'
    )
    def copy(self):
        contract = Contract.get(self.request.params.get('id'))
        return {
            'item': contract,
            'title': _(u"Copy Contract")
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
        renderer='travelcrm:templates/contract/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Contracts'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        ids = self.request.params.getall('id')
        if ids:
            try:
                (
                    DBSession.query(Contract)
                    .filter(Contract.id.in_(ids))
                    .delete()
                )
            except:
                DBSession.rollback()
                return {
                    'error_message': _(
                        u'Some objects could not be delete'
                    ),
                }
        return {'success_message': _(u'Deleted')}
