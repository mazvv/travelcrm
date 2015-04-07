# -*-coding: utf-8 -*-

import colander

from . import BaseSearchForm
from ..resources.general_service import GeneralServiceResource
from ..forms.order_item import (
    OrderItemSchema,
    OrderItemForm
)
from ..models.general_service import GeneralService
from ..lib.qb.order_item import OrderItemQueryBuilder


class GeneralServiceSchema(OrderItemSchema):
    pass


class GeneralServiceForm(OrderItemForm):
    _schema = GeneralServiceSchema

    def submit(self, general_service=None):
        context = GeneralServiceResource(self.request)
        if not general_service:
            general_service = GeneralService(
                resource=context.create_resource()
            )
        general_service.order_item = (
            super(OrderItemForm, self).submit(general_service.order_item)
        )


class GeneralServiceSearchForm(BaseSearchForm):
    _qb = OrderItemQueryBuilder
