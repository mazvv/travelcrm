# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.lead import Lead
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.leads import LeadsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.leads import (
    LeadSchema, 
    LeadSearchSchema
)


log = logging.getLogger(__name__)


class Leads(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.leads.Leads',
        request_method='GET',
        renderer='travelcrm:templates/leads/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.leads.Leads',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        schema = LeadSearchSchema().bind(request=self.request)
        controls = schema.deserialize(self.request.params.mixed())
        qb = LeadsQueryBuilder(self.context)
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
        context='..resources.leads.Leads',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            lead = Lead.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': lead.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Lead"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.leads.Leads',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Lead')}

    @view_config(
        name='add',
        context='..resources.leads.Leads',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = LeadSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            lead = Lead(
                lead_date=controls.get('lead_date'),
                customer_id=controls.get('customer_id'),
                advsource_id=controls.get('advsource_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                lead.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                lead.resource.tasks.append(task)
            DBSession.add(lead)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': lead.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.leads.Leads',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mak',
        permission='edit'
    )
    def edit(self):
        lead = Lead.get(self.request.params.get('id'))
        return {'item': lead, 'title': _(u'Edit Lead')}

    @view_config(
        name='edit',
        context='..resources.leads.Leads',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = LeadSchema().bind(request=self.request)
        lead = Lead.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            lead.lead_date = controls.get('lead_date')
            lead.customer_id = controls.get('customer_id')
            lead.advsource_id = controls.get('advsource_id')
            lead.resource.notes = []
            lead.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                lead.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                lead.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': lead.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.leads.Leads',
        request_method='GET',
        renderer='travelcrm:templates/leads/form.mak',
        permission='add'
    )
    def copy(self):
        lead = Lead.get(self.request.params.get('id'))
        return {
            'item': lead,
            'title': _(u"Copy Lead")
        }

    @view_config(
        name='copy',
        context='..resources.leads.Leads',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.leads.Leads',
        request_method='GET',
        renderer='travelcrm:templates/leads/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Leads'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.leads.Leads',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Lead.get(id)
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
