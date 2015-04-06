# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.advsource import Advsource
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.advsource import AdvsourceQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.advsource import (
    AdvsourceForm, 
    AdvsourceSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.advsource.AdvsourceResource',
)
class AdvsourceView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/advsource/index.mak',
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
        form = AdvsourceSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/advsource/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            advsource = Advsource.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': advsource.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Advsource"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/advsource/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Advertising Source')}

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = AdvsourceForm(self.request)
        if form.validate():
            advsource = form.submit()
            DBSession.add(advsource)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': advsource.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/advsource/form.mak',
        permission='edit'
    )
    def edit(self):
        advsource = Advsource.get(self.request.params.get('id'))
        return {'item': advsource, 'title': _(u'Edit Advertising Source')}

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        advsource = Advsource.get(self.request.params.get('id'))
        form = AdvsourceForm(self.request)
        if form.validate():
            form.submit(advsource)
            return {
                'success_message': _(u'Saved'),
                'response': advsource.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/advsource/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Advertises Sources'),
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
            item = Advsource.get(id)
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
