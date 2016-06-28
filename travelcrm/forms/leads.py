# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    Date,
    ResourceSchema,
    ResourceSearchSchema,
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.leads import LeadsResource
from ..models.lead import Lead
from ..models.person import Person
from ..models.advsource import Advsource
from ..models.note import Note
from ..models.task import Task
from ..models.lead_item import LeadItem
from ..models.lead_offer import LeadOffer
from ..lib.qb.leads import LeadsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _LeadSchema(ResourceSchema):
    lead_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        SelectInteger(Person),
    )
    advsource_id = colander.SchemaNode(
        SelectInteger(Advsource),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    lead_offer_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )
    lead_item_id = colander.SchemaNode(
        colander.Set(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )

    def deserialize(self, cstruct):
        if (
            'lead_item_id' in cstruct
            and not isinstance(cstruct.get('lead_item_id'), list)
        ):
            val = cstruct['lead_item_id']
            cstruct['lead_item_id'] = list()
            cstruct['lead_item_id'].append(val)

        if (
            'lead_offer_id' in cstruct
            and not isinstance(cstruct.get('lead_offer_id'), list)
        ):
            val = cstruct['lead_offer_id']
            cstruct['lead_offer_id'] = list()
            cstruct['lead_offer_id'].append(val)

        return super(_LeadSchema, self).deserialize(cstruct)


class LeadForm(BaseForm):
    _schema = _LeadSchema

    def submit(self, lead=None):
        if not lead:
            lead = Lead(
                resource=LeadsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            lead.leads_offers = []
            lead.leads_items = []
            lead.resource.notes = []
            lead.resource.tasks = []
        lead.lead_date = self._controls.get('lead_date')
        lead.customer_id = self._controls.get('customer_id')
        lead.advsource_id = self._controls.get('advsource_id')
        lead.status = self._controls.get('status')
        lead.descr = self._controls.get('descr')
        for id in self._controls.get('lead_offer_id'):
            lead_offer = LeadOffer.get(id)
            lead.leads_offers.append(lead_offer)
        for id in self._controls.get('lead_item_id'):
            lead_item = LeadItem.get(id)
            lead.leads_items.append(lead_item)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            lead.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            lead.resource.tasks.append(task)
        return lead


class _LeadSearchSchema(ResourceSearchSchema):
    service_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    status = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    price_from = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    price_to = colander.SchemaNode(
        colander.Money(),
        missing=None,
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    lead_from = colander.SchemaNode(
        Date(),
        missing=None,
    )
    lead_to = colander.SchemaNode(
        Date(),
        missing=None,
    )


class LeadSearchForm(BaseSearchForm):
    _qb = LeadsQueryBuilder
    _schema = _LeadSearchSchema


class LeadAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            lead = Lead.get(id)
            lead.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
