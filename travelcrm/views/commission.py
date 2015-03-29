# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.commission import Commission
from ..lib.qb.commission import CommissionQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.commission import CommissionSchema


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.commission.CommissionResource',
)
class CommissionView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/commissions/index.mak',
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
        qb = CommissionQueryBuilder(self.context)
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
        request_method='GET',
        renderer='travelcrm:templates/commissions/form.mak',
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
        renderer='travelcrm:templates/commissions/form.mak',
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
        schema = CommissionSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            commission = Commission(
                date_from=controls.get('date_from'),
                service_id=controls.get('service_id'),
                percentage=controls.get('percentage'),
                price=controls.get('price'),
                currency_id=controls.get('currency_id'),
                resource=self.context.create_resource()
            )
            DBSession.add(commission)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': commission.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/commissions/form.mak',
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
        schema = CommissionSchema().bind(request=self.request)
        commission = Commission.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            commission.date_from = controls.get('date_from')
            commission.service_id = controls.get('service_id')
            commission.percentage = controls.get('percentage')
            commission.price = controls.get('price')
            commission.currency_id = controls.get('currency_id')
            return {
                'success_message': _(u'Saved'),
                'response': commission.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/commissions/form.mak',
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
        renderer='travelcrm:templates/commissions/delete.mak',
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = Commission.get(id)
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
