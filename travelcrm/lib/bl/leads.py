# -*coding: utf-8-*-

from ...models import DBSession
from ...models.lead import Lead
from ...models.lead_item import LeadItem
from ...resources.leads_items import LeadsItemsResource
from ...lib.utils.security_utils import get_auth_employee


def get_lead_copy(lead_id, request):
    lead = Lead.get(lead_id)

    leads_items = []
    for lead_item in list(lead.leads_items):
        lead_item = LeadItem.get_copy(lead_item.id)
        resource = LeadsItemsResource.create_resource(
            get_auth_employee(request)
        )        
        DBSession.add(resource)
        DBSession.flush([resource,])
        lead_item.resource = resource
        leads_items.append(lead_item)
    DBSession.add_all(leads_items)
    DBSession.flush(leads_items)

    lead = Lead.get_copy(lead.id)
    lead.leads_items = leads_items
    return lead
