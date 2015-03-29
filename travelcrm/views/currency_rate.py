# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.currency_rate import CurrencyRate
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.currency_rate import CurrencyRateQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.currency_rate import (
    CurrencyRateSchema, 
    CurrencyRateSearchSchema
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
        renderer='travelcrm:templates/currencies_rates/index.mak',
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
        schema = CurrencyRateSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = CurrencyRateQueryBuilder(self.context)
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
        renderer='travelcrm:templates/currencies_rates/form.mak',
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
        renderer='travelcrm:templates/currencies_rates/form.mak',
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
        schema = CurrencyRateSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            currency_rate = CurrencyRate(
                currency_id=controls.get('currency_id'),
                rate=controls.get('rate'),
                date=controls.get('date'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                currency_rate.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                currency_rate.resource.tasks.append(task)
            DBSession.add(currency_rate)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': currency_rate.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/form.mak',
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
        schema = CurrencyRateSchema().bind(request=self.request)
        currency_rate = CurrencyRate.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            currency_rate.currency_id = controls.get('currency_id')
            currency_rate.rate = controls.get('rate')
            currency_rate.date = controls.get('date')
            currency_rate.resource.notes = []
            currency_rate.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                currency_rate.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                currency_rate.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': currency_rate.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/currencies_rates/form.mak',
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
        renderer='travelcrm:templates/currencies_rates/delete.mak',
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = CurrencyRate.get(id)
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
