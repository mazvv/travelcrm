# -*-coding: utf-8 -*-

import colander

from . import(
    Date,
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.passports import PassportsResource
from ..models.country import Country
from ..models.passport import Passport
from ..models.upload import Upload
from ..lib.qb.passports import PassportsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if not value and request.params.get('passport_type') == 'foreign':
            raise colander.Invalid(
                node,
                _(u"You must set end date for foreign passport")
            )
    return validator


class _PassportSchema(ResourceSchema):
    country_id = colander.SchemaNode(
        SelectInteger(Country),
    )
    passport_type = colander.SchemaNode(
        colander.String(),
    )
    num = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=24)
    )
    end_date = colander.SchemaNode(
        Date(),
        missing=None,
        validator=date_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(min=2, max=255)
    )
    upload_id = colander.SchemaNode(
        colander.Set(),
        missing=[]
    )
    def deserialize(self, cstruct):
        if (
            'upload_id' in cstruct
            and not isinstance(cstruct.get('upload_id'), list)
        ):
            val = cstruct['upload_id']
            cstruct['upload_id'] = list()
            cstruct['upload_id'].append(val)

        return super(_PassportSchema, self).deserialize(cstruct)


class PassportForm(BaseForm):
    _schema = _PassportSchema

    def submit(self, passport=None):
        if not passport:
            passport = Passport(
                resource=PassportsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            passport.uploads = []
            passport.resource.notes = []
            passport.resource.tasks = []
        passport.num = self._controls.get('num')
        passport.country_id = self._controls.get('country_id')
        passport.passport_type = self._controls.get('passport_type')
        passport.end_date = self._controls.get('end_date')
        passport.descr = self._controls.get('descr')
        for id in self._controls.get('upload_id'):
            upload = Upload.get(id)
            passport.uploads.append(upload)
        return passport


class PassportSearchForm(BaseSearchForm):
    _qb = PassportsQueryBuilder
