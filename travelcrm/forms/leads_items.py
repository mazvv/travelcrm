# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.leads_items import LeadsItemsResource
from ..models.lead_item import LeadItem
from ..models.currency import Currency
from ..models.service import Service
from ..lib.qb.leads_items import LeadsItemsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _LeadItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        SelectInteger(Service),
    )
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
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
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
    )


class LeadItemForm(BaseForm):
    _schema = _LeadItemSchema

    def submit(self, lead_item=None):
        if not lead_item:
            lead_item = LeadItem(
                resource=LeadsItemsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )

        lead_item.service_id = self._controls.get('service_id')
        lead_item.currency_id = self._controls.get('currency_id')
        lead_item.price_from = self._controls.get('price_from')
        lead_item.price_to = self._controls.get('price_to')
        lead_item.descr = self._controls.get('descr')
        return lead_item


class LeadItemSearchForm(BaseSearchForm):
    _qb = LeadsItemsQueryBuilder
