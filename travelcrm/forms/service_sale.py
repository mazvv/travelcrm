# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
    ResourceSearchSchema
)


class ServiceSaleSchema(ResourceSchema):
    deal_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        colander.Integer(),
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
    )
    service_item_id = colander.SchemaNode(
        colander.Set(),
    )

    def deserialize(self, cstruct):
        if (
            'service_item_id' in cstruct
            and not isinstance(cstruct.get('service_item_id'), list)
        ):
            val = cstruct['service_item_id']
            cstruct['service_item_id'] = list()
            cstruct['service_item_id'].append(val)

        return super(ServiceSaleSchema, self).deserialize(cstruct)


class ServiceSaleSearchSchema(ResourceSearchSchema):
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
