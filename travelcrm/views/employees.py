# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.employee import Employee
from ..lib.qb.employees import EmployeesQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.employees import EmployeeSchema


log = logging.getLogger(__name__)


class Employees(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.employees.Employees',
        request_method='GET',
        renderer='travelcrm:templates/employees/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.employees.Employees',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = EmployeesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
            status=self.request.params.get('status'),
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
        name='add',
        context='..resources.employees.Employees',
        request_method='GET',
        renderer='travelcrm:templates/employees/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Employee')}

    @view_config(
        name='add',
        context='..resources.employees.Employees',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = EmployeeSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            employee = Employee(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(employee)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': employee.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.employees.Employees',
        request_method='GET',
        renderer='travelcrm:templates/employees/form.mak',
        permission='edit'
    )
    def edit(self):
        employee = Employee.get(self.request.params.get('id'))
        return {'item': employee, 'title': _(u'Edit Employee')}

    @view_config(
        name='edit',
        context='..resources.employees.Employees',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = EmployeeSchema().bind(request=self.request)
        employee = Employee.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            employee.first_name = controls.get('first_name')
            employee.last_name = controls.get('last_name')
            employee.second_name = controls.get('second_name')
            employee.resource.status = controls.get('status')
            return {
                'success_message': _(u'Saved'),
                'response': employee.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.employees.Employees',
        request_method='GET',
        renderer='travelcrm:templates/employees/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.employees.Employees',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            employee = Employee.get(id)
            if employee:
                DBSession.delete(employee)
        return {'success_message': _(u'Deleted')}
