# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.licence import Licence
from ..lib.qb.licences import LicencesQueryBuilder

from ..forms.licences import LicenceSchema


log = logging.getLogger(__name__)


class Licences(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.licences.Licences',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = LicencesQueryBuilder(self.context)
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
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {
            'title': _(u'Add Licence'),
        }

    @view_config(
        name='add',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = LicenceSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            licence = Licence(
                licence_num=controls.get('licence_num'),
                date_from=controls.get('date_from'),
                date_to=controls.get('date_to'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(licence)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': licence.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        licence = Licence.get(self.request.params.get('id'))
        return {
            'item': licence,
            'title': _(u'Edit Licence'),
        }

    @view_config(
        name='edit',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = LicenceSchema().bind(request=self.request)
        licence = Licence.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            licence.licence_num = controls.get('licence_num')
            licence.date_from = controls.get('date_from')
            licence.date_to = controls.get('date_to')
            licence.resource.status = controls.get('status')
            return {
                'success_message': _(u'Saved'),
                'response': licence.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/form.mak',
        permission='add'
    )
    def copy(self):
        _ = self.request.translate
        licence = Licence.get(self.request.params.get('id'))
        return {
            'item': licence,
            'title': _(u"Copy Licence")
        }

    @view_config(
        name='copy',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            licence = Licence.get(id)
            if licence:
                DBSession.delete(licence)
        return {'success_message': _(u'Deleted')}
