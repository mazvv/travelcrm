# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseSearchForm,
)
from .common import service_validator
from ..lib.qb.invoices_items import InvoicesItemsQueryBuilder


class _InvoiceItemSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        colander.String(),
        validator=service_validator
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
