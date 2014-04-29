# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.passport import Passport
from ..lib.qb.passports import PassportsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.passports import PassportSchema


log = logging.getLogger(__name__)


class Passports(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.passports.Passports',
        request_method='GET',
        renderer='travelcrm:templates/passports/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.passports.Passports',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = PassportsQueryBuilder(self.context)
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
        name='add',
        context='..resources.passports.Passports',
        request_method='GET',
        renderer='travelcrm:templates/passports/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Passport'),
        }

    @view_config(
        name='add',
        context='..resources.passports.Passports',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = PassportSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            passport = Passport(
                num=controls.get('num'),
                country_id=controls.get('country_id'),
                passport_type=controls.get('passport_type'),
                end_date=controls.get('end_date'),
                descr=controls.get('descr'),
                resource=self.context.create_resource()
            )
            DBSession.add(passport)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': passport.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.passports.Passports',
        request_method='GET',
        renderer='travelcrm:templates/passports/form.mak',
        permission='edit'
    )
    def edit(self):
        passport = Passport.get(self.request.params.get('id'))
        return {
            'item': passport,
            'title': _(u'Edit Passport'),
        }

    @view_config(
        name='edit',
        context='..resources.passports.Passports',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = PassportSchema().bind(request=self.request)
        passport = Passport.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            passport.num = controls.get('num')
            passport.country_id = controls.get('country_id')
            passport.passport_type = controls.get('passport_type')
            passport.end_date = controls.get('end_date')
            passport.descr = controls.get('descr')
            return {
                'success_message': _(u'Saved'),
                'response': passport.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.passports.Passports',
        request_method='GET',
        renderer='travelcrm:templates/passports/form.mak',
        permission='add'
    )
    def copy(self):
        passport = Passport.get(self.request.params.get('id'))
        return {
            'item': passport,
            'title': _(u"Copy Passport")
        }

    @view_config(
        name='copy',
        context='..resources.passports.Passports',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.passports.Passports',
        request_method='GET',
        renderer='travelcrm:templates/passports/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.passports.Passports',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            passport = Passport.get(id)
            if passport:
                DBSession.delete(passport)
        return {'success_message': _(u'Deleted')}
