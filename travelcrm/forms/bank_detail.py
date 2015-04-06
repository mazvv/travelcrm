# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm
)
from ..resources.bank_detail import BankDetailResource
from ..models.bank_detail import BankDetail
from ..lib.qb.bank_detail import BankDetailQueryBuilder


class _BankDetailSchema(ResourceSchema):
    currency_id = colander.SchemaNode(
        colander.Integer(),
    )
    bank_id = colander.SchemaNode(
        colander.Integer(),
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
        context = BankDetailResource(self.request)
        if not bank_detail:
            bank_detail = BankDetail(
                resource=context.create_resource()
            )
        bank_detail.bank_id = self._controls.get('bank_id')
        bank_detail.currency_id = self._controls.get('currency_id')
        bank_detail.beneficiary = self._controls.get('beneficiary')
        bank_detail.account = self._controls.get('account')
        bank_detail.swift_code = self._controls.get('swift_code')
        return bank_detail


class BankDetailSearchForm(BaseSearchForm):
    _qb = BankDetailQueryBuilder
