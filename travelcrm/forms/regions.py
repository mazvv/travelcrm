# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.regions import RegionsResource
from ..models import DBSession
from ..models.region import Region
from ..models.country import Country
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.regions import RegionsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        region = (
            DBSession.query(Region).filter(
                Region.name == value,
                Region.country_id == request.params.get('country_id')
            ).first()
        )
        if (
            region
            and str(region.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Region already exists'),
            )
    return colander.All(colander.Length(max=128), validator,)


class _RegionSchema(ResourceSchema):
    country_id = colander.SchemaNode(
        SelectInteger(Country),
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )


class RegionForm(BaseForm):
    _schema = _RegionSchema

    def submit(self, region=None):
        context = RegionsResource(self.request)
        if not region:
            region = Region(
                resource=RegionsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            region.resource.notes = []
            region.resource.tasks = []
        region.name = self._controls.get('name')
        region.country_id = self._controls.get('country_id')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            region.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            region.resource.tasks.append(task)
        return region


class RegionSearchForm(BaseSearchForm):
    _qb = RegionsQueryBuilder


class RegionAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            region = Region.get(id)
            region.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
