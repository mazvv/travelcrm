# -*-coding: utf-8-*-

from datetime import datetime
from cgi import FieldStorage

import colander
import phonenumbers
from colander import (
    Date as ColanderDate,
    Invalid,
    null,
    _
)

from ..lib.qb import ResourcesQueryBuilder
from ..lib.utils.common_utils import (
    get_locale_name, 
    parse_datetime
)


class ResourceSchema(colander.Schema):
    note_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    task_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'note_id' in cstruct
            and not isinstance(cstruct.get('note_id'), list)
        ):
            val = cstruct['note_id']
            cstruct['note_id'] = list()
            cstruct['note_id'].append(val)
        if (
            'task_id' in cstruct
            and not isinstance(cstruct.get('task_id'), list)
        ):
            val = cstruct['task_id']
            cstruct['task_id'] = list()
            cstruct['task_id'].append(val)

        return super(ResourceSchema, self).deserialize(cstruct)


class Date(ColanderDate):

    def deserialize(self, node, cstruct):
        if not cstruct:
            return null
        try:
            result = parse_datetime(cstruct)
        except:
            raise Invalid(
                node,
                _(
                    self.err_template,
                    mapping={'val': cstruct}
                )
            )
        return result


class DateTime(ColanderDate):

    def deserialize(self, node, cstruct):
        if not cstruct:
            return null
        try:
            result = parse_datetime(cstruct)
        except:
            raise Invalid(
                node,
                _(
                    self.err_template,
                    mapping={'val': cstruct}
                )
            )
        return result


class PhoneNumber(object):

    def __call__(self, node, value):
        try:
            phone = phonenumbers.parse(value)
        except phonenumbers.NumberParseException:
            raise Invalid(
                node,
                _(
                    u"Phone must be in format +XXXXXXXXXXX "
                    u"and contains country code",
                    mapping={'val': value}
                )
            )
        if not phonenumbers.is_valid_number(phone):
            raise Invalid(
                node,
                _(
                    u"Phone is not valid",
                    mapping={'val': value}
                )
            )


class File(colander.SchemaType):

    def serialize(self, node, appstruct):
        if appstruct is colander.null:
            return colander.null
        return appstruct

    def deserialize(self, node, cstruct):
        if cstruct is None or not isinstance(cstruct, FieldStorage):
            return colander.null
        return cstruct


class ResourceSearchSchema(colander.Schema):
    id = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    q = colander.SchemaNode(
        colander.String(),
        missing=None
    )
    updated_from = colander.SchemaNode(
        Date(),
        missing=None
    )
    updated_to = colander.SchemaNode(
        Date(),
        missing=None
    )
    modifier_id = colander.SchemaNode(
        colander.Int(),
        missing=None
    )
    sort = colander.SchemaNode(
        colander.String(),
    )
    order = colander.SchemaNode(
        colander.String(),
        validator=colander.OneOf(('asc', 'desc')),
    )
    rows = colander.SchemaNode(
        colander.Integer(),
    )
    page = colander.SchemaNode(
        colander.Integer(),
    )


class BaseForm(object):
    _schema = None
    _controls = None
    _errors = None

    def __init__(self, request):
        assert self._schema, u'Set _schema class attribute'
        self.request = request
        self.schema = self._schema().bind(request=self.request)

    def validate(self):
        try:
            self._controls = self.schema.deserialize(
                self.request.params.mixed()
            )
            return True
        except colander.Invalid as e:
            self._errors = e.asdict()
            return False

    @property
    def errors(self):
        return self._errors

    def submit(self, obj=None):
        raise NotImplementedError(u'Submit method must be implemented')


class BaseSearchForm(BaseForm):
    _schema = ResourceSearchSchema
    _qb = None

    def __init__(self, request, context):
        assert self._qb, u'Set _qb class attribute'
        self.qb = self._qb(context)
        super(BaseSearchForm, self).__init__(request)

    def submit(self):
        self.qb.search_simple(self._controls.get('q'))
        self.qb.advanced_search(**self._controls)
        id = self._controls.get('id')
        if id:
            self.qb.filter_id(id.split(','))
        self.qb.sort_query(
            self._controls.get('sort'),
            self._controls.get('order', 'asc')
        )
        self.qb.page_query(
            self._controls.get('rows'),
            self._controls.get('page')
        )
        return self.qb
