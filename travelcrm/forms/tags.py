# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.tags import TagsResource
from ..models.tag import Tag
from ..lib.qb.tags import TagsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        tag = Tag.by_name(value)
        if (
            tag
            and str(tag.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Tag with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _TagSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )


class TagForm(BaseForm):
    _schema = _TagSchema

    def submit(self, tag=None):
        if not tag:
            tag = Tag(
                resource=TagsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            tag.resource.notes = []
            tag.resource.tasks = []
        tag.name = self._controls.get('name')
        return tag


class TagSearchForm(BaseSearchForm):
    _qb = TagsQueryBuilder


class TagAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            tag = Tag.get(id)
            tag.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
