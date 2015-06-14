# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm
)
from ..resources.countries import CountriesResource
from ..models.country import Country
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.countries import CountriesQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def iso_code_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        country = Country.by_iso_code(value)
        if (
            country
            and str(country.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Country with the same iso code exists'),
            )
    return colander.All(colander.Length(min=2, max=2), validator,)


class _CountrySchema(ResourceSchema):
    iso_code = colander.SchemaNode(
        colander.String(),
        validator=iso_code_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=32),
    )


class CountryForm(BaseForm):
    _schema = _CountrySchema

    def submit(self, country=None):
        context = CountriesResource(self.request)
        if not country:
            country = Country(
                resource=context.create_resource()
            )
        else:
            country.resource.notes = []
            country.resource.tasks = []
        country.name = self._controls.get('name')
        country.iso_code = self._controls.get('iso_code')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            country.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            country.resource.tasks.append(task)
        return country


class CountrySearchForm(BaseSearchForm):
    _qb = CountriesQueryBuilder
