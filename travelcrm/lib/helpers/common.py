# -*coding: utf-8-*-

import pkg_resources
import json
from datetime import datetime

from webhelpers2.html import tags
from webhelpers2.html import HTML
from webhelpers2.misc import NotGiven

from ..utils.common_utils import (
    gen_id as u_gen_id,
    get_locale_name as u_get_locale_name,
    get_company_name as u_get_company_name,
    format_date as u_format_date,
    format_datetime as u_format_datetime,
    format_decimal as u_format_decimal,
    get_base_currency as u_get_base_currency,
    format_currency as u_format_currency,
    get_multicompanies as u_get_multicompanies,
    get_default_locale_name as u_get_default_locale_name,
    get_tarifs as u_get_tarifs,
    jsonify as _jsonify,
)
from ..utils.security_utils import get_auth_employee as u_get_auth_employee
from ..utils.companies_utils import (
    get_company_url as u_get_company_url,
    can_create_company as u_can_create_company,
    get_public_domain as u_get_public_domain,
)
from ..bl.employees import get_employee_structure
from ..bl.tarifs import get_tarifs_list as u_get_tarifs_list


def reset(name, value=None, id=NotGiven, **attrs):
    return tags.text(name, value, id, type="reset", **attrs)


def get_package_version(package_name):
    version = u'<uknown>'
    try:
        version = pkg_resources.get_distribution(package_name).version
    finally:
        return version


def error_container(name, as_text=False):
    return HTML.tag(
        'span',
        class_='error %s hidden'
        % ('fa fa-arrow-circle-down as-text' if as_text else 'fa fa-exclamation-circle'),
        c=HTML.tag('span'),
        **{'data-name': name}
    )


def gen_id(prefix=u'obj', limit=6):
    return u_gen_id(prefix, limit)


def button(context, permision, caption, **kwargs):
    html = ''
    if context.has_permision(permision):
        caption = HTML.tag('span', c=caption)
        icon = ''
        if 'icon' in kwargs:
            icon = HTML.tag('span', class_=kwargs.pop('icon'))
        button_class = "button _action " + kwargs.pop('class', '')
        button_class = button_class.strip()
        html = HTML.tag(
            'a', class_=button_class,
            c=HTML(icon, caption), **kwargs
        )
    return html


def jsonify(val):
    return _jsonify(val)


def get_company_name():
    return u_get_company_name()


def contact_type_icon(contact_type):
    assert contact_type.key in (u'phone', u'email', u'skype'), \
        u"wrong contact type"
    if contact_type.key == u'phone':
        return HTML.tag('span', class_='fa fa-phone')
    elif contact_type.key == u'email':
        return HTML.tag('span', class_='fa fa-envelope')
    else:
        return HTML.tag('span', class_='fa fa-skype')


def format_decimal(value):
    return u_format_decimal(value)


def format_currency(value, currency):
    return u_format_currency(value, currency)


def format_date(value):
    return u_format_date(value)


def format_datetime(value):
    return u_format_datetime(value)


def get_locale_name():
    return u_get_locale_name()


def get_current_employee_structure(request):
    return get_employee_structure(u_get_auth_employee(request))


def get_base_currency():
    return u_get_base_currency()


def get_auth_employee(request):
    return u_get_auth_employee(request)


def get_company_url(request, schema_name):
    return u_get_company_url(request, schema_name)


def get_multicompanies():
    return u_get_multicompanies()


def can_create_company(request):
    return u_can_create_company(request)


def is_public_domain(request):
    return u_get_public_domain() == request.domain


def today():
    return datetime.today().date()


def get_default_locale_name():
    return u_get_default_locale_name()


def get_tarifs():
    return u_get_tarifs()


def get_tarifs_list():
    return u_get_tarifs_list()
