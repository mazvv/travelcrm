# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from .common import currency_validator
from ..lib.qb.companies import CompaniesQueryBuilder
from ..lib.scheduler.companies import schedule_company_creation


class _CompanyAddSchema(ResourceSchema):
    email = colander.SchemaNode(
        colander.String(),
        validator=colander.All(colander.Email(), colander.Length(max=32))
    )
    name = colander.SchemaNode(
        colander.String(),
    )
    timezone = colander.SchemaNode(
        colander.String(),
    )
    locale = colander.SchemaNode(
        colander.String(),
    )
    currency_id = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=currency_validator,
    )


class _CompanySchema(_CompanyAddSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
        validator=currency_validator,
    )


class CompanyForm(BaseForm):
    _schema = _CompanySchema

    def submit(self, company=None):
        if not company:
            schedule_company_creation(
                self.request,
                self._controls.get('name'),
                self._controls.get('email'),
                self._controls.get('timezone'),
                self._controls.get('locale')
            )
            return
        company.name = self._controls.get('name')
        company.email = self._controls.get('email')
        company.currency_id = self._controls.get('currency_id')
        company.settings = {
            'timezone': self._controls.get('timezone'),
            'locale': self._controls.get('locale'),
        }
        return company


class CompanyAddForm(CompanyForm):
    _schema = _CompanyAddSchema


class CompanySearchForm(BaseSearchForm):
    _qb = CompaniesQueryBuilder
