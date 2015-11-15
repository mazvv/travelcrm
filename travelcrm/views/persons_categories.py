# -*-coding: utf-8-*-

import logging

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from . import BaseView
from ..models import DBSession
from ..models.person_category import PersonCategory
from ..lib.utils.common_utils import translate as _

from ..forms.persons_categories import (
    PersonCategoryForm, 
    PersonCategorySearchForm
)


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.persons_categories.PersonsCategoriesResource',
)
class PersonsCategoriesView(BaseView):

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/persons_categories/index.mako',
        permission='view'
    )
    def index(self):
        return {
            'title': self._get_title(),
        }

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        form = PersonCategorySearchForm(self.request, self.context)
        form.validate()
        qb = form.submit()
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        request_method='GET',
        renderer='travelcrm:templates/persons_categories/form.mako',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            person_category = PersonCategory.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': person_category.id}
                )
            )
        result = self.edit()
        result.update({
            'title': self._get_title(_(u'View')),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/persons_categories/form.mako',
        permission='add'
    )
    def add(self):
        return {
            'title': self._get_title(_(u'Add')),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        form = PersonCategoryForm(self.request)
        if form.validate():
            person_category = form.submit()
            DBSession.add(person_category)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': person_category.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/persons_categories/form.mako',
        permission='edit'
    )
    def edit(self):
        person_category = PersonCategory.get(self.request.params.get('id'))
        return {
            'item': person_category, 
            'title': self._get_title(_(u'Edit')),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        person_category = PersonCategory.get(self.request.params.get('id'))
        form = PersonCategoryForm(self.request)
        if form.validate():
            form.submit(person_category)
            return {
                'success_message': _(u'Saved'),
                'response': person_category.id
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/persons_categories/delete.mako',
        permission='delete'
    )
    def delete(self):
        return {
            'title': self._get_title(_(u'Delete')),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = False
        ids = self.request.params.getall('id')
        if ids:
            try:
                items = DBSession.query(PersonCategory).filter(
                    PersonCategory.id.in_(ids)
                )
                for item in items:
                    DBSession.delete(item)
            except:
                errors=True
                DBSession.rollback()
        if errors:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
