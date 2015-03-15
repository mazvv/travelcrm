# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.bank import Bank
from ..models.address import Address
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.banks import BanksQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.banks import (
    BankSchema, 
    BankSearchSchema
)


log = logging.getLogger(__name__)


class Banks(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.banks.Banks',
        request_method='GET',
        renderer='travelcrm:templates/banks/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.banks.Banks',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = BankSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = BanksQueryBuilder(self.context)
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
        context='..resources.banks.Banks',
        request_method='GET',
        renderer='travelcrm:templates/banks/form.mak',
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
        context='..resources.banks.Banks',
        request_method='GET',
        renderer='travelcrm:templates/banks/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Bank')}

    @view_config(
        name='add',
        context='..resources.banks.Banks',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = BankSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            bank = Bank(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('address_id'):
                address = Address.get(id)
                bank.addresses.append(address)
            for id in controls.get('note_id'):
                note = Note.get(id)
                bank.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                bank.resource.tasks.append(task)
            DBSession.add(bank)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bank.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.banks.Banks',
        request_method='GET',
        renderer='travelcrm:templates/banks/form.mak',
        permission='edit'
    )
    def edit(self):
        bank = Bank.get(self.request.params.get('id'))
        return {'item': bank, 'title': _(u'Edit Bank')}

    @view_config(
        name='edit',
        context='..resources.banks.Banks',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = BankSchema().bind(request=self.request)
        bank = Bank.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            bank.name = controls.get('name')
            bank.addresses = []
            bank.resource.notes = []
            bank.resource.tasks = []
            for id in controls.get('address_id'):
                address = Address.get(id)
                bank.addresses.append(address)
            for id in controls.get('note_id'):
                note = Note.get(id)
                bank.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                bank.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': bank.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.banks.Banks',
        request_method='GET',
        renderer='travelcrm:templates/banks/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Banks'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.banks.Banks',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Bank.get(id)
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
