# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.bank import Bank
from ..models.address import Address
from ..lib.qb.banks import BanksQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.banks import BankSchema


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
        qb = BanksQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
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
            controls = schema.deserialize(self.request.params)
            bank = Bank(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            if self.request.params.getall('address_id'):
                bank.addresses = (
                    DBSession.query(Bank)
                    .filter(
                        Bank.id.in_(
                            self.request.params.getall('address_id')
                        )
                    )
                    .all()
                )
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
        return {'item': bank, 'title': _(u'Edit Hotel Category')}

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
            controls = schema.deserialize(self.request.params)
            bank.name = controls.get('name')
            if self.request.params.getall('address_id'):
                bank.addresses = (
                    DBSession.query(Address)
                    .filter(
                        Address.id.in_(
                            self.request.params.getall('address_id')
                        )
                    )
                    .all()
                )
            else:
                bank.addresses = []
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
        for id in self.request.params.getall('id'):
            bank = Bank.get(id)
            if bank:
                DBSession.delete(bank)
        return {'success_message': _(u'Deleted')}
