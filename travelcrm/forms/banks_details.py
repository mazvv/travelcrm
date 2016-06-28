# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm
)
from ..resources.banks_details import BanksDetailsResource
from ..models.bank_detail import BankDetail
from ..models.currency import Currency
from ..models.bank import Bank
from ..lib.qb.banks_details import BanksDetailsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _BankDetailSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        SelectInteger(Currency),
    )
    bank_id = colander.SchemaNode(
        SelectInteger(Bank),
    )
    beneficiary = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255)
    )
    account = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32)
    )
    swift_code = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32)
    )


class BankDetailForm(BaseForm):
    _schema = _BankDetailSchema

    def submit(self, bank_detail=None):
        if not bank_detail:
            bank_detail = BankDetail(
                resource=BanksDetailsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        bank_detail.bank_id = self._controls.get('bank_id')
        bank_detail.currency_id = self._controls.get('currency_id')
        bank_detail.beneficiary = self._controls.get('beneficiary')
        bank_detail.account = self._controls.get('account')
        bank_detail.swift_code = self._controls.get('swift_code')
        return bank_detail


class BankDetailSearchForm(BaseSearchForm):
    _qb = BanksDetailsQueryBuilder
