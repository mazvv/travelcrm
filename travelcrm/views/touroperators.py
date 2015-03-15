# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.resource import Resource
from ..models.touroperator import Touroperator
from ..models.licence import Licence
from ..models.bperson import BPerson
from ..models.bank_detail import BankDetail
from ..models.commission import Commission
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.touroperators import TouroperatorsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.helpers.fields import touroperators_combobox_field
from ..forms.touroperators import (
    TouroperatorSchema, 
    TouroperatorSearchSchema
)


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
        schema = TouroperatorSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = TouroperatorsQueryBuilder(self.context)
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
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            touroperator = Touroperator.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': touroperator.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Touroperator"),
            'readonly': True,
        })
        return result

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
            controls = schema.deserialize(self.request.params.mixed())
            touroperator = Touroperator(
                name=controls.get('name'),
                resource=self.context.create_resource()
            )
            for id in controls.get('licence_id'):
                licence = Licence.get(id)
                touroperator.licences.append(licence)
            for id in controls.get('bperson_id'):
                bperson = BPerson.get(id)
                touroperator.bpersons.append(bperson)
            for id in controls.get('bank_detail_id'):
                bank_detail = BankDetail.get(id)
                touroperator.banks_details.append(bank_detail)
            for id in controls.get('commission_id'):
                commission = Commission.get(id)
                touroperator.commissions.append(commission)
            for id in controls.get('note_id'):
                note = Note.get(id)
                touroperator.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                touroperator.resource.tasks.append(task)
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
            controls = schema.deserialize(self.request.params.mixed())
            touroperator.name = controls.get('name')
            touroperator.licences = []
            touroperator.bpersons = []
            touroperator.banks_details = []
            touroperator.commissions = []
            touroperator.resource.notes = []
            touroperator.resource.tasks = []
            for id in controls.get('licence_id'):
                licence = Licence.get(id)
                touroperator.licences.append(licence)
            for id in controls.get('bperson_id'):
                bperson = BPerson.get(id)
                touroperator.bpersons.append(bperson)
            for id in controls.get('bank_detail_id'):
                bank_detail = BankDetail.get(id)
                touroperator.banks_details.append(bank_detail)
            for id in controls.get('commission_id'):
                commission = Commission.get(id)
                touroperator.commissions.append(commission)
            for id in controls.get('note_id'):
                note = Note.get(id)
                touroperator.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                touroperator.resource.tasks.append(task)
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
        name='details',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/details.mak',
        permission='view'
    )
    def details(self):
        touroperator = Touroperator.get(self.request.params.get('id'))
        return {
            'item': touroperator,
        }

    @view_config(
        name='delete',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Touroperators'),
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
        errors = 0
        for id in self.request.params.getall('id'):
            item = Touroperator.get(id)
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

    @view_config(
        name='combobox',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        permission='view'
    )
    def _combobox(self):
        value = None
        resource = Resource.get(self.request.params.get('resource_id'))
        if resource:
            value = resource.touroperator.id
        return Response(
            touroperators_combobox_field(
                self.request, value, name=self.request.params.get('name')
            )
        )
