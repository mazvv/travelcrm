# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound
from pyramid.response import FileResponse

from ..models import DBSession
from ..models.upload import Upload
from ..lib.utils.common_utils import translate as _

from ..forms.uploads import (
    UploadForm,
    UploadSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.uploads.UploadsResource',
)
class UploadsView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/uploads/index.mako',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        form = UploadSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/uploads/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            upload = Upload.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': upload.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Upload"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/uploads/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Upload'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = UploadForm(self.request)
        if form.validate():
            upload = form.submit()
            DBSession.add(upload)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': upload.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/uploads/form.mako',
        permission='edit'
    )
    def edit(self):
        upload = Upload.get(self.request.params.get('id'))
        return {
            'item': upload,
            'title': _(u'Edit Upload'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        upload = Upload.get(self.request.params.get('id'))
        form = UploadForm(self.request)
        if form.validate():
            form.submit(upload)
            return {
                'success_message': _(u'Saved'),
                'response': upload.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/uploads/form.mako',
        permission='add'
    )
    def copy(self):
        upload = Upload.get(self.request.params.get('id'))
        return {
            'item': upload,
            'title': _(u"Copy Upload")
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/uploads/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Uploads'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        ids = self.request.params.getall('id')
        if ids:
            try:
                (
                    DBSession.query(Upload)
                    .filter(Upload.id.in_(ids))
                    .delete()
                )
            except:
                DBSession.rollback()
                return {
                    'error_message': _(
                        u'Some objects could not be delete'
                    ),
                }
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='download',
        request_method='GET',
        permission='view'
    )
    def download(self):
        upload = Upload.get(self.request.params.get('id'))
        response = FileResponse(
            self.request.storage.base_path + '/' + upload.path,
            request=self.request,
        )
        return response        
