# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.commission import Commission
from ..lib.qb.commissions import CommissionsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.commissions import (
    CommissionForm,
    CommissionSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.commissions.CommissionsResource',
)
class CommissionsView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/contacts/index.mako',
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
        form = CommissionSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            commission = Commission.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': commission.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Commission"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Commission'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = CommissionForm(self.request)
        if form.validate():
            commission = form.submit()
            DBSession.add(commission)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': commission.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='edit'
    )
    def edit(self):
        commission = Commission.get(self.request.params.get('id'))
        return {
            'item': commission,
            'title': _(u'Edit Commission'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        commission = Commission.get(self.request.params.get('id'))
        form = CommissionForm(self.request)
        if form.validate():
            form.submit(commission)
            return {
                'success_message': _(u'Saved'),
                'response': commission.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/contacts/form.mako',
        permission='add'
    )
    def copy(self):
        commission = Commission.get(self.request.params.get('id'))
        return {
            'item': commission,
            'title': _(u"Copy Commission")
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
        renderer='travelcrm:templates/contacts/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Commissions'),
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
                    DBSession.query(Commission)
                    .filter(Commission.id.in_(ids))
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
