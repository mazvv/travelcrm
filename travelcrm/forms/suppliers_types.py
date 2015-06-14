# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm
)
from ..resources.suppliers_types import SuppliersTypesResource
from ..models.supplier_type import SupplierType
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.suppliers_types import SuppliersTypesQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        supplier_type = SupplierType.by_name(value)
        if (
            supplier_type
            and str(supplier_type.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Hotel category with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _SupplierTypeSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )


class SupplierTypeForm(BaseForm):
    _schema = _SupplierTypeSchema

    def submit(self, supplier_type=None):
        context = SuppliersTypesResource(self.request)
        if not supplier_type:
            supplier_type = SupplierType(
                resource=context.create_resource()
            )
        else:
            supplier_type.resource.notes = []
            supplier_type.resource.tasks = []
        supplier_type.name = self._controls.get('name')
        supplier_type.descr = self._controls.get('descr')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            supplier_type.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            supplier_type.resource.tasks.append(task)
        return supplier_type


class SupplierTypeSearchForm(BaseSearchForm):
    _qb = SuppliersTypesQueryBuilder
