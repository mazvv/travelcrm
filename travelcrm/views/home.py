# -*-coding: utf-8-*-

from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound
)
from pyramid.security import (
    remember,
    forget,
)
from pyramid.view import view_config
from pyramid.view import forbidden_view_config

from ..resources import Root
from ..models.user import User
from ..lib.bl.employees import get_employee_structure
from ..lib.utils.common_utils import translate as _
from ..lib.utils.companies_utils import can_create_company
from ..lib.utils.resources_utils import get_resource_class
from ..lib.utils.resources_utils import get_resources_types_by_interface
from ..interfaces import IPortlet
from ..forms.auth import (
    LoginSchema,
    ForgotForm
)
from ..forms.companies import CompanyAddForm


class HomeView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        context='..resources.Root',
        renderer='travelcrm:templates/home.mako',
        permission='view'
    )
    def index(self):
        portlets = []
        for portlet in get_resources_types_by_interface(IPortlet):
            column_index = (
                portlet.settings 
                and portlet.settings.get('column_index', 1)
            )
            if column_index is None:
                continue
            rt_cls = get_resource_class(portlet.name)
            url = self.request.resource_url(rt_cls(self.request))
            portlets.append({'column_index': column_index, 'url': url})
        return {
            'portlets': portlets
        }

    @view_config(
        name='forgot',
        request_method='GET',
        context='..resources.Root',
        renderer='travelcrm:templates/auth/forgot.mako',
    )
    def forgot(self):
        if self.request.params.get('success'):
            self.request.override_renderer = \
                'travelcrm:templates/auth/forgot_success.mako'
        auth_url = self.request.resource_url(
            Root(self.request),
            'auth'
        )
        return {'auth_url': auth_url}

    @view_config(
        name='forgot',
        request_method='POST',
        context='..resources.Root',
        renderer='json',
    )
    def _forgot(self):
        form = ForgotForm(self.request)
        if form.validate():
            form.submit()
            return {
                'close': False,
                'success_message': _(u'Check your email box.'),
                'redirect': self.request.resource_url(
                    self.context, 'forgot', query={'success': 'ok'}
                )
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }

    @forbidden_view_config(
        request_method="GET",
        renderer="travelcrm:templates/auth/login.mako",
    )
    @view_config(
        name='auth',
        request_method='GET',
        context='..resources.Root',
        renderer='travelcrm:templates/auth/login.mako',
    )
    def auth(self):
        if self.request.authenticated_userid:
            return HTTPFound(
                location=self.request.resource_url(self.context)
            )

        forgot_url = self.request.resource_url(
            Root(self.request),
            'forgot'
        )
        auth_url = self.request.resource_url(
            Root(self.request),
            'auth'
        )
        add_url = self.request.resource_url(
            Root(self.request),
            'add'
        )
        return {
            'forgot_url': forgot_url,
            'auth_url': auth_url,
            'add_url': add_url,
        }

    @view_config(
        name='auth',
        request_method='POST',
        context='..resources.Root',
        renderer='json',
    )
    def _auth(self):
        schema = LoginSchema()

        controls = schema.deserialize(self.request.params)
        user = User.by_username(controls.get('username'))
        if (user
            and user.validate_password(controls.get('password'))
            and user.employee
            and get_employee_structure(user.employee)
        ):
            self.request.response.headers = remember(self.request, user.id)
            return {
                'redirect': self.request.resource_url(self.context),
                'success_message': _(u"Success, wait...")
            }
        return {
            'error_message': _(u'Invalid username or password'),
        }

    @view_config(
        name='logout',
        request_method='GET',
        context='..resources.Root',
        renderer='travelcrm:templates/auth/logout.mako'
    )
    def logout(self):
        return {}

    @view_config(
        name='logout',
        request_method='POST',
        context='..resources.Root'
    )
    def _logout(self):
        redirect_url = self.request.resource_url(Root(self.request))
        return HTTPFound(location=redirect_url, headers=forget(self.request))


    @view_config(
        name='add',
        context='..resources.Root',
        request_method='GET',
        renderer='travelcrm:templates/auth/add.mako',
    )
    def add(self):
        if not can_create_company(self.request):
            return HTTPNotFound()
        if self.request.params.get('success'):
            self.request.override_renderer = \
                'travelcrm:templates/auth/add_success.mako'
        auth_url = self.request.resource_url(
            Root(self.request),
            'auth'
        )
        return {'auth_url': auth_url}

    @view_config(
        name='add',
        context='..resources.Root',
        request_method='POST',
        renderer='json',
    )
    def _add(self):
        form = CompanyAddForm(self.request)
        if form.validate():
            form.submit()
            return {
                'close': False,
                'success_message': _(
                    u'Creation task run soon. Waiting for Email.'
                ),
                'redirect': self.request.resource_url(
                    self.context, 'add', query={'success': 'ok'}
                )
            }
        else:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': form.errors
            }
