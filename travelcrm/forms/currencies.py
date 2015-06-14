# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.currencies import CurrenciesResource
from ..models.currency import Currency
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.currencies import CurrenciesQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def iso_code_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        currency = Currency.by_iso_code(value)
        if (
            currency
            and str(currency.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Currency with the same iso code exists'),
            )
    return colander.All(colander.Length(min=3, max=3), validator,)


class _CurrencySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
        validator=iso_code_validator
    )


class CurrencyForm(BaseForm):
    _schema = _CurrencySchema

    def submit(self, currency=None):
        context = CurrenciesResource(self.request)
        if not currency:
            currency = Currency(
                resource=context.create_resource()
            )
        else:
            currency.resource.notes = []
            currency.resource.tasks = []
        currency.iso_code = self._controls.get('iso_code')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            currency.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            currency.resource.tasks.append(task)
        return currency


class CurrencySearchForm(BaseSearchForm):
    _qb = CurrenciesQueryBuilder
