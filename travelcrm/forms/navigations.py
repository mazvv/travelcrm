# -*-coding: utf-8 -*-

import colander

from . import(
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    ResourceSearchSchema,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.navigations import NavigationsResource
from ..models.navigation import Navigation
from ..models.position import Position
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.navigations import NavigationsQueryBuilder
from ..lib.bl.navigations import (
    get_next_sort_order,
    copy_from_position,
    update_sort_orders,
)
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def parent_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if request.params.get('id') and str(value) == request.params.get('id'):
            raise colander.Invalid(
                node,
                _(u'Can not be parent of self'),
            )
    return validator


class _NavigationSchema(ResourceSchema):
    position_id = colander.SchemaNode(
        SelectInteger(Position)
    )
    parent_id = colander.SchemaNode(
        SelectInteger(Navigation),
        missing=None,
        validator=parent_validator
    )
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=128)
    )
    url = colander.SchemaNode(
        colander.String(),
        missing='',
        validator=colander.Length(max=128)
    )
    action = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32)
    )
    icon_cls = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=32)
    )
    separator_before = colander.SchemaNode(
        colander.Boolean(false_choices=("", "0", "false"), true_choices=("1")),
        missing=False
    )


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


class NavigationForm(BaseForm):
    _schema = _NavigationSchema

    def submit(self, navigation=None):
        if not navigation:
            navigation = Navigation(
                resource=NavigationsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
            update_sort_orders(
                self._controls.get('position_id'),
                self._controls.get('parent_id')
            )
            navigation.sort_order = get_next_sort_order(
                self._controls.get('position_id'),
                self._controls.get('parent_id')
            )
        else:
            navigation.resource.notes = []
            navigation.resource.tasks = []
        navigation.name = self._controls.get('name')
        navigation.position_id = self._controls.get('position_id')
        navigation.parent_id = self._controls.get('parent_id')
        navigation.url= self._controls.get('url')
        navigation.action = self._controls.get('action')
        navigation.icon_cls = self._controls.get('icon_cls')
        navigation.separator_before = self._controls.get('separator_before')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            navigation.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            navigation.resource.tasks.append(task)
        return navigation


class _NavigationSearchSchema(ResourceSearchSchema):
    position_id = colander.SchemaNode(
        colander.Integer(),
        missing=None,
    )
    with_chain = colander.SchemaNode(
        colander.String(),
        missing=None,
    )
    

class NavigationSearchForm(BaseSearchForm):
    _schema = _NavigationSearchSchema
    _qb = NavigationsQueryBuilder

    def _search(self):
        self.qb.filter_position_id(self._controls.get('position_id'))
        parent_id = self._controls.get('id')
        self.qb.filter_parent_id(
            parent_id,
            with_chain=self._controls.get('with_chain')
        )


class _NavigationCopySchema(colander.Schema):
    position_id = colander.SchemaNode(
        colander.Integer()
    )
    from_position_id = colander.SchemaNode(
        colander.Integer(),
        validator=position_validator
    )


class NavigationCopyForm(BaseForm):
    _schema = _NavigationCopySchema

    def submit(self):
        copy_from_position(
            self.request,
            self._controls.get('from_position_id'),
            self._controls.get('position_id'),
        )        


class NavigationAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            navigation = Navigation.get(id)
            navigation.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
