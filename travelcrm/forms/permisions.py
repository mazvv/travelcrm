# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    BaseForm,
    ResourceSearchSchema,
    BaseSearchForm,
)
from ..models import DBSession
from ..models.permision import Permision
from ..models.position import Position
from ..models.resource_type import ResourceType
from ..models.structure import Structure
from ..lib.qb.permisions import PermisionsQueryBuilder
from ..lib.bl.permisions import copy_from_position
from ..lib.utils.common_utils import translate as _


@colander.deferred
def scope_type_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value == 'structure' and not request.params.get('structure_id'):
            raise colander.Invalid(
                node,
                _(u'Set structure for scope'),
            )
    return colander.All(validator,)


class _PermisionSchema(colander.Schema):
    position_id = colander.SchemaNode(
        SelectInteger(Position),
    )
    resource_type_id = colander.SchemaNode(
        SelectInteger(ResourceType),
    )
    scope_type = colander.SchemaNode(
        colander.String(),
        missing='all',
        validator=scope_type_validator
    )
    structure_id = colander.SchemaNode(
        SelectInteger(Structure),
        missing=None
    )
    permisions = colander.Set()


class PermisionForm(BaseForm):
    _schema = _PermisionSchema

    def submit(self):
        permision = (
            DBSession.query(Permision)
            .filter(
                Permision.condition_position_id(
                    self._controls.get('position_id')
                ),
                Permision.condition_resource_type_id(
                    self._controls.get('resource_type_id')
                )
            )
            .first()
        )
        if not permision:
            permision = Permision(
                position_id=self._controls.get('position_id'),
                resource_type_id=self._controls.get('resource_type_id'),
            )
        permisions = self.request.params.getall('permisions')
        permisions = filter(None, permisions)
        permision.permisions = permisions
        permision.scope_type = self._controls.get('scope_type')
        if permision.scope_type == 'structure':
            permision.structure_id = (
                self._controls.get('structure_id')
            )
        else:
            permision.structure_id = None
        return permision


class _PermisionSearchSchema(ResourceSearchSchema):
    position_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    

class PermisionSearchForm(BaseSearchForm):
    _schema = _PermisionSearchSchema
    _qb = PermisionsQueryBuilder

    def __init__(self, request, context):
        assert self._qb, u'Set _qb class attribute'
        #TODO: it's shitty, must be rewriten
        self.qb = self._qb(request.params.get('position_id'))
        super(BaseSearchForm, self).__init__(request)


@colander.deferred
def position_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if value == int(request.params.get('position_id')):
            raise colander.Invalid(
                node,
                _(u'Can not copy to itself'),
            )
    return colander.All(validator,)


class _PermisionCopySchema(colander.Schema):
    position_id = colander.SchemaNode(
        colander.Integer()
    )
    from_position_id = colander.SchemaNode(
        colander.Integer(),
        validator=position_validator
    )


class PermisionCopyForm(BaseForm):
    _schema = _PermisionCopySchema

    def submit(self):
        copy_from_position(
            self._controls.get('from_position_id'),
            self._controls.get('position_id'),
        )        
