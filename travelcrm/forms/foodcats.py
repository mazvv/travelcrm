# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema
from ..models.foodcat import Foodcat
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        foodcat = Foodcat.by_name(value)
        if (
            foodcat
            and str(foodcat.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Food category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class FoodcatSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
