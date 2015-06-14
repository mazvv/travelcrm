# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)

from ..models.company import Company
from ..resources.companies import CompaniesResource
from ..lib.qb.companies import CompaniesQueryBuilder
from ..lib.utils.common_utils import serialize


class _CompanySchema(ResourceSchema):
    email = colander.SchemaNode(
        colander.String(),
        validator=colander.All(colander.Email(), colander.Length(max=32))
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.All(colander.Length(max=32))
    )
    timezone = colander.SchemaNode(
        colander.String(),
    )
    locale = colander.SchemaNode(
        colander.String(),
    )
    currency_id = colander.SchemaNode(
        colander.Integer()
    )
    vat = colander.SchemaNode(
        colander.Money(),
        missing=0,
        validator=colander.Range(min=0, max=100)
    )


class CompanyForm(BaseForm):
    _schema = _CompanySchema

    def submit(self, company=None):
        context = CompaniesResource(self.request)
        if not company:
            company = Company(
                resource=context.create_resource()
            )
        company.name = self._controls.get('name')
        company.email = self._controls.get('email')
        company.currency_id = self._controls.get('currency_id')
        company.settings = {
            'timezone': self._controls.get('timezone'),
            'locale': self._controls.get('locale'),
            'vat': serialize(self._controls.get('vat')),
        }
        return company


class CompanySearchForm(BaseSearchForm):
    _qb = CompaniesQueryBuilder
