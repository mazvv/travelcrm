# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.commissions import CommissionsResource
from ..models.commission import Commission
from ..lib.qb.commissions import CommissionsQueryBuilder


class _CommissionSchema(ResourceSchema):
    service_id = colander.SchemaNode(
        colander.Integer()
    )
    percentage = colander.SchemaNode(
        colander.Decimal(),
        validator=colander.Range(min=0, max=100)
    )
    price = colander.SchemaNode(
        colander.Money(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )


class CommissionForm(BaseForm):
    _schema = _CommissionSchema

    def submit(self, commission=None):
        context = CommissionsResource(self.request)
        if not commission:
            commission = Commission(
                resource=context.create_resource()
            )
        commission.service_id = self._controls.get('service_id')
        commission.percentage = self._controls.get('percentage')
        commission.price = self._controls.get('price')
        commission.currency_id = self._controls.get('currency_id')
        commission.descr = self._controls.get('descr')
        return commission


class CommissionSearchForm(BaseSearchForm):
    _qb = CommissionsQueryBuilder
