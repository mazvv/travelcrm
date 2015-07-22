# -*coding: utf-8-*-

from ...models.user import User


def get_auth_employee(request):
    user = User.get(request.authenticated_userid)
    if user:
        return user.employee
