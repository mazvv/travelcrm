# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.company import Company
from ..lib.qb.companies import CompaniesQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.companies import CompanySchema


log = logging.getLogger(__name__)


class Companies(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.companies.Companies',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = CompaniesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='view',
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Company"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Company')}

    @view_config(
        name='add',
        context='..resources.companies.Companies',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = CompanySchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            company = Company(
                name=controls.get('name'),
                currency_id=controls.get('currency_id'),
                settings={
                    'timezone': controls.get('timezone'),
                    'locale': controls.get('locale')
                },
                resource=self.context.create_resource()
            )
            DBSession.add(company)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': company.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/form.mak',
        permission='edit'
    )
    def edit(self):
        company = Company.get(self.request.params.get('id'))
        return {'item': company, 'title': _(u'Edit Company')}

    @view_config(
        name='edit',
        context='..resources.companies.Companies',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = CompanySchema().bind(request=self.request)
        company = Company.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            company.name = controls.get('name')
            company.currency_id = controls.get('currency_id')
            settings = {
                'timezone': controls.get('timezone'),
                'locale': controls.get('locale')
            }
            company.settings = settings
            return {
                'success_message': _(u'Saved'),
                'response': company.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.companies.Companies',
        request_method='GET',
        renderer='travelcrm:templates/companies/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Companies'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.companies.Companies',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Company.get(id)
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
