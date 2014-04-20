# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.touroperator import Touroperator
from ..models.licence import Licence
from ..models.bperson import BPerson
from ..models.contact import Contact
from ..lib.qb.touroperators import TouroperatorsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.touroperators import TouroperatorSchema


log = logging.getLogger(__name__)


class Touroperators(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.touroperators.Touroperators',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = TouroperatorsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
            status=self.request.params.get('status'),
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
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Touroperator'),
        }

    @view_config(
        name='add',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = TouroperatorSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            touroperator = Touroperator(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            if self.request.params.getall('licence_id'):
                touroperator.licences = (
                    DBSession.query(Licence)
                    .filter(
                        Licence.id.in_(
                            self.request.params.getall('licence_id')
                        )
                    )
                    .all()
                )
            if self.request.params.getall('bperson_id'):
                touroperator.bpersons = (
                    DBSession.query(BPerson)
                    .filter(
                        BPerson.id.in_(
                            self.request.params.getall('bperson_id')
                        )
                    )
                    .all()
                )
            DBSession.add(touroperator)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': touroperator.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form.mak',
        permission='edit'
    )
    def edit(self):
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
            'title': _(u'Edit Touroperator'),
        }

    @view_config(
        name='edit',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = TouroperatorSchema().bind(request=self.request)
        touroperator = Touroperator.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            touroperator.name = controls.get('name')
            touroperator.resource.status = controls.get('status')
            if self.request.params.getall('licence_id'):
                touroperator.licences = (
                    DBSession.query(Licence)
                    .filter(
                        Licence.id.in_(
                            self.request.params.getall('licence_id')
                        )
                    )
                    .all()
                )
            else:
                touroperator.licences = []
            if self.request.params.getall('bperson_id'):
                touroperator.bpersons = (
                    DBSession.query(BPerson)
                    .filter(
                        BPerson.id.in_(
                            self.request.params.getall('bperson_id')
                        )
                    )
                    .all()
                )
            else:
                touroperator.bpersons = []
            return {
                'success_message': _(u'Saved'),
                'response': touroperator.id,
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form.mak',
        permission='add'
    )
    def copy(self):
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
            'title': _(u"Copy Touroperator")
        }

    @view_config(
        name='copy',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            touroperator = Touroperator.get(id)
            if touroperator:
                DBSession.delete(touroperator)
        return {'success_message': _(u'Deleted')}
