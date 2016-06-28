# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..resources.leads_offers import LeadsOffersResource
from ..models.lead_offer import LeadOffer
from ..models.currency import Currency
from ..models.supplier import Supplier
from ..models.service import Service
from ..lib.qb.leads_offers import LeadsOffersQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _LeadOfferSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        SelectInteger(Service),
    )
    supplier_id = colander.SchemaNode(
        SelectInteger(Supplier),
    )
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
    )
    price = colander.SchemaNode(
        colander.Money(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
    )


class LeadOfferForm(BaseForm):
    _schema = _LeadOfferSchema

    def submit(self, lead_offer=None):
        if not lead_offer:
            lead_offer = LeadOffer(
                resource=LeadsOffersResource.create_resource(
                    get_auth_employee(self.request)
                )
            )

        lead_offer.service_id = self._controls.get('service_id')
        lead_offer.currency_id = self._controls.get('currency_id')
        lead_offer.supplier_id = self._controls.get('supplier_id')
        lead_offer.price = self._controls.get('price')
        lead_offer.status = self._controls.get('status')
        lead_offer.descr = self._controls.get('descr')
        return lead_offer


class LeadOfferSearchForm(BaseSearchForm):
    _qb = LeadsOffersQueryBuilder
