# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.accomodation_type import AccomodationType
from ..lib.utils.common_utils import translate as _
from ..forms.accomodation_type import (
    AccomodationTypeForm,
    AccomodationTypeSearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.accomodation_type.AccomodationTypeResource',
)
class AccomodationTypeView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/accomodation_type/index.mak',
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
        form = AccomodationTypeSearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/resources_types/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            accomodation_type = AccomodationType.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': accomodation_type.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Accomodation Type"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/accomodation_type/form.mak',
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
        form = AccomodationTypeForm(self.request)
        if form.validate():
            accomodation_type = form.submit()
            DBSession.add(accomodation_type)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': accomodation_type.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/accomodation_type/form.mak',
        permission='edit'
    )
    def edit(self):
        accomodation_type = AccomodationType.get(self.request.params.get('id'))
        return {
            'item': accomodation_type,
            'title': _(u'Edit Accomodation Type')
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        accomodation_type = AccomodationType.get(self.request.params.get('id'))
        form = AccomodationTypeForm(self.request)
        if form.validate():
            form.submit(accomodation_type)
            return {
                'success_message': _(u'Saved'),
                'response': accomodation_type.id,
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/accomodation_type/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Accomodation Types'),
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
            item = AccomodationType.get(id)
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
