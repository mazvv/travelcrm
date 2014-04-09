# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.touroperator import Touroperator
from ..models.licence import Licence
from ..models.person import Person
from ..lib.qb.tours_deals import ToursDealsQueryBuilder
from ..forms.tours_deals import TourDealSchema


log = logging.getLogger(__name__)


class ToursDeals(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.tours_deals.Toursdeals',
        request_method='GET',
        renderer='travelcrm:templates/tours_deals/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.tours_deals.Toursdeals',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = ToursDealsQueryBuilder(self.context)
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
        context='..resources.tours_deals.Toursdeals',
        request_method='GET',
        renderer='travelcrm:templates/tours_deals/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {
            'title': _(u'Add Tour Deal'),
        }

    @view_config(
        name='add',
        context='..resources.tours_deals.Toursdeals',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = TourDealSchema().bind(request=self.request)
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
        context='..resources.tours_deals.Toursdeals',
        request_method='GET',
        renderer='travelcrm:templates/tours_deals/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
            'title': _(u'Edit Touroperator'),
        }

    @view_config(
        name='edit',
        context='..resources.tours_deals.Toursdeals',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
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
        context='..resources.tours_deals.Toursdeals',
        request_method='GET',
        renderer='travelcrm:templates/tours_deals/form.mak',
        permission='add'
    )
    def copy(self):
        _ = self.request.translate
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
            'title': _(u"Copy Touroperator")
        }

    @view_config(
        name='copy',
        context='..resources.tours_deals.Toursdeals',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.tours_deals.Toursdeals',
        request_method='GET',
        renderer='travelcrm:templates/tours_deals/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.tours_deals.Toursdeals',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            touroperator = Touroperator.get(id)
            if touroperator:
                DBSession.delete(touroperator)
        return {'success_message': _(u'Deleted')}
