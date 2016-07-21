# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema,
    BaseForm,
    BaseSearchForm,
)
from ..lib.qb.companies import CompaniesQueryBuilder
from ..models.currency import Currency
from ..lib.scheduler.companies import schedule_company_creation
from ..lib.bl.tarifs import get_tarif_by_code
from ..lib.utils.common_utils import get_tarifs


@colander.deferred
def tarif_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if not get_tarifs():
            return
        if not get_tarif_by_code(value):
            raise colander.Invalid(
                node,
                _(u'Tarif doe not exists'),
            )
    return validator


class _CompanyAddSchema(ResourceSchema):
    tarif = colander.SchemaNode(
        colander.String(),
        validator=tarif_validator,
        missing=None,
    )
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
        SelectInteger(Currency),
        missing=None,
    )


class _CompanySchema(_CompanyAddSchema):
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
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
                self._controls.get('locale'),
                self._controls.get('tarif'),
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
