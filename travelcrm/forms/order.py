# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
    ResourceSearchSchema
)


class OrderSchema(ResourceSchema):
    deal_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        colander.Integer(),
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
    )
    order_item_id = colander.SchemaNode(
        colander.Set(),
    )

    def deserialize(self, cstruct):
        if (
            'order_item_id' in cstruct
            and not isinstance(cstruct.get('order_item_id'), list)
        ):
            val = cstruct['order_item_id']
            cstruct['order_item_id'] = list()
            cstruct['order_item_id'].append(val)

        return super(OrderSchema, self).deserialize(cstruct)


class OrderSearchSchema(ResourceSearchSchema):
    person_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    service_id = colander.SchemaNode(
        colander.Integer(),
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
    sale_from = colander.SchemaNode(
        Date(),
        missing=None,
    )
    sale_to = colander.SchemaNode(
        Date(),
        missing=None,
    )
