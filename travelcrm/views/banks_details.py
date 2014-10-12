# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.bank_detail import BankDetail
from ..lib.qb.banks_details import BanksDetailsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.banks_details import BankDetailSchema


log = logging.getLogger(__name__)


class BankDetails(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.banks_details.BanksDetails',
        request_method='GET',
        renderer='travelcrm:templates/banks_details/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.banks_details.BanksDetails',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = BanksDetailsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
        structure_id = self.request.params.get('structure_id')
        if structure_id:
            qb.filter_structure_id(structure_id.split(','))
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
        context='..resources.banks_details.BanksDetails',
        request_method='GET',
        renderer='travelcrm:templates/banks_details/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Bank Detail"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.banks_details.BanksDetails',
        request_method='GET',
        renderer='travelcrm:templates/banks_details/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Bank Detail'),
        }

    @view_config(
        name='add',
        context='..resources.banks_details.BanksDetails',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = BankDetailSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            bank_detail = BankDetail(
                bank_id=controls.get('bank_id'),
                currency_id=controls.get('currency_id'),
                beneficiary=controls.get('beneficiary'),
                account=controls.get('account'),
                swift_code=controls.get('swift_code'),
                resource=self.context.create_resource()
            )
            DBSession.add(bank_detail)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bank_detail.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.banks_details.BanksDetails',
        request_method='GET',
        renderer='travelcrm:templates/banks_details/form.mak',
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
        context='..resources.banks_details.BanksDetails',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = BankDetailSchema().bind(request=self.request)
        bank_detail = BankDetail.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            bank_detail.bank_id = controls.get('bank_id')
            bank_detail.currency_id = controls.get('currency_id')
            bank_detail.beneficiary = controls.get('beneficiary')
            bank_detail.account = controls.get('account')
            bank_detail.swift_code = controls.get('swift_code')
            return {
                'success_message': _(u'Saved'),
                'response': bank_detail.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='details',
        context='..resources.banks_details.BanksDetails',
        request_method='GET',
        renderer='travelcrm:templates/banks_details/details.mak',
        permission='view'
    )
    def details(self):
        bank_detail = BankDetail.get(self.request.params.get('id'))
        return {
            'item': bank_detail,
        }

    @view_config(
        name='delete',
        context='..resources.banks_details.BanksDetails',
        request_method='GET',
        renderer='travelcrm:templates/banks_details/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Banks Details'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.banks_details.BanksDetails',
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
