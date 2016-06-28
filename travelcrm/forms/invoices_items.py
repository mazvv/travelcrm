# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseSearchForm,
)
from ..models.service import Service
from ..lib.qb.invoices_items import InvoicesItemsQueryBuilder


class _InvoiceItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        SelectInteger(Service),
    )
    price = colander.SchemaNode(
        colander.Money()
    )
    vat = colander.SchemaNode(
        colander.Money()
    )
    discount = colander.SchemaNode(
        colander.Money(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255)
    )


class InvoiceItemSearchForm(BaseSearchForm):
    _qb = InvoicesItemsQueryBuilder
