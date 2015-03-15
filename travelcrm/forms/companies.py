# -*-coding: utf-8 -*-

import colander

from . import ResourceSchema

from ..models.company import Company
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        company = Company.by_name(value)
        if (
            company
            and str(company.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Company with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class CompanyAddSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    timezone = colander.SchemaNode(
        colander.String(),
    )
    locale = colander.SchemaNode(
        colander.String(),
    )


class CompanySchema(CompanyAddSchema):
    currency_id = colander.SchemaNode(
        colander.Integer()
    )
