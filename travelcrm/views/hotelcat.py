# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.hotelcat import Hotelcat
from ..lib.utils.common_utils import translate as _

from ..forms.hotelcat import (
    HotelcatForm, 
    HotelcatSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.hotelcat.HotelcatResource',
)
class HotelcatView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/hotelcat/index.mak',
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
    def list(self):
        form = HotelcatSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/hotelcat/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            hotelcat = Hotelcat.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': hotelcat.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Hotel Category"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/hotelcat/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Hotel Category')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = HotelcatForm(self.request)
        if form.validate():
            hotelcat = form.submit()
            DBSession.add(hotelcat)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': hotelcat.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/hotelcat/form.mak',
        permission='edit'
    )
    def edit(self):
        hotelcat = Hotelcat.get(self.request.params.get('id'))
        return {'item': hotelcat, 'title': _(u'Edit Hotel Category')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        hotelcat = Hotelcat.get(self.request.params.get('id'))
        form = HotelcatForm(self.request)
        if form.validate():
            form.submit(hotelcat)
            return {
                'success_message': _(u'Saved'),
                'response': hotelcat.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/hotelcat/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Hotel Categories'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Hotelcat.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
