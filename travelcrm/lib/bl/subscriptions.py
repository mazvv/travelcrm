#-*-coding:utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.employee import Employee
from ..utils.security_utils import get_auth_employee


def subscribe_resource(request, resource):
    """subscribe current employee to resource
    """
    employee = get_auth_employee(request)
    is_subscription_exists = (
        DBSession.query(Resource.id)
        .join(Employee, Resource.subscribers)
        .filter(Employee.id == employee.id, Resource.id == resource.id)
        .scalar()
    )
    if not is_subscription_exists:
        resource.subscribers.append(employee)
    else:
        resource.subscribers.remove(employee)
