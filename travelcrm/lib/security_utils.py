# -*coding: utf-8-*-

from pyramid.security import authenticated_userid

from ..models.user import User


def get_auth_employee(request):
    user = User.get(authenticated_userid(request))
    if user:
        return user.employee
