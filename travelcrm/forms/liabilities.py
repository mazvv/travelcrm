# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema, Date


class LiabilitySchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
    )
    liability_item_id = colander.SchemaNode(
        colander.Set(),
    )
    description = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )

    def deserialize(self, cstruct):
        if (
            'liability_item_id' in cstruct
            and not isinstance(cstruct.get('liability_item_id'), list)
        ):
            val = cstruct['liability_item_id']
            cstruct['liability_item_id'] = list()
            cstruct['liability_item_id'].append(val)

        return super(LiabilitySchema, self).deserialize(cstruct)


class LiabilityAddSchema(LiabilitySchema):
    resource_id = colander.SchemaNode(
        colander.Integer(),
    )
