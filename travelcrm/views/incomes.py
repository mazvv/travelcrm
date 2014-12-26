# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.income import Income
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.incomes import IncomesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.bl.incomes import make_payment

from ..forms.incomes import IncomeSchema


log = logging.getLogger(__name__)


class Incomes(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.incomes.Incomes',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = IncomesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
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
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Income"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Income')}

    @view_config(
        name='add',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = IncomeSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            income = Income(
                invoice_id=controls.get('invoice_id'),
                resource=self.context.create_resource()
            )
            income.transfers = make_payment(
                self.context,
                controls.get('invoice_id'),
                controls.get('date'),
                controls.get('sum')
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                income.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                income.resource.tasks.append(task)
            DBSession.add(income)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': income.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/form.mak',
        permission='edit'
    )
    def edit(self):
        income = Income.get(self.request.params.get('id'))
        return {'item': income, 'title': _(u'Edit Income')}

    @view_config(
        name='edit',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = IncomeSchema().bind(request=self.request)
        income = Income.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            income.rollback()
            income.invoice_id = controls.get('invoice_id')
            income.transfers = make_payment(
                self.context,
                controls.get('invoice_id'),
                controls.get('date'),
                controls.get('sum')
            )
            income.resource.notes = []
            income.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                income.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                income.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': income.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.incomes.Incomes',
        request_method='GET',
        renderer='travelcrm:templates/incomes/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Income Payments'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.incomes.Incomes',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Income.get(id)
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
