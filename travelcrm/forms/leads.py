# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    ResourceSchema,
    ResourceSearchSchema,
)


class LeadSchema(ResourceSchema):
    lead_date = colander.SchemaNode(
        Date()
    )
    customer_id = colander.SchemaNode(
        colander.Integer(),
    )
    advsource_id = colander.SchemaNode(
        colander.Integer(),
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    wish_item_id = colander.SchemaNode(
        colander.Set(),
    )
    offer_item_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )

    def deserialize(self, cstruct):
        if (
            'wish_item_id' in cstruct
            and not isinstance(cstruct.get('wish_item_id'), list)
        ):
            val = cstruct['wish_item_id']
            cstruct['wish_item_id'] = list()
            cstruct['wish_item_id'].append(val)

        if (
            'offer_item_id' in cstruct
            and not isinstance(cstruct.get('offer_item_id'), list)
        ):
            val = cstruct['offer_item_id']
            cstruct['offer_item_id'] = list()
            cstruct['offer_item_id'].append(val)

        return super(LeadSchema, self).deserialize(cstruct)


class LeadSearchSchema(ResourceSearchSchema):
    pass
