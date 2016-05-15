# -*-coding: utf-8 -*-

import colander

from . import(
    File,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.uploads import UploadsResource
from ..models.upload import Upload
from ..lib.qb.uploads import UploadsQueryBuilder
from ..lib.bl.storages import (
    is_allowed_file_size,
    get_file_size
)
from ..lib.utils.common_utils import get_storage_dir
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def upload_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if not is_allowed_file_size(value.file):
            raise colander.Invalid(
                node,
                _(u'File is too big')
            )
        try:
            request.storage.file_allowed(value, request.storage.extensions)
        except:
            raise colander.Invalid(
                node,
                _(u'This files types is not allowed'),
            )
        value.file.seek(0)

    return colander.All(validator,)


class _UploadSchema(ResourceSchema):
    upload = colander.SchemaNode(
        File(),
        validator=upload_validator
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )


class UploadForm(BaseForm):
    _schema = _UploadSchema

    def submit(self, upload=None):
        if not upload:
            upload = Upload(
                resource=UploadsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        upload.path = self.request.storage.save(
            self._controls.get('upload'),
            folder=get_storage_dir(),
            randomize=True
        )
        upload.name=self._controls.get('upload').filename
        upload.size=get_file_size(self._controls.get('upload').file)
        upload.media_type=self._controls.get('upload').type
        upload.descr = self._controls.get('descr')
        return upload


class UploadSearchForm(BaseSearchForm):
    _qb = UploadsQueryBuilder
