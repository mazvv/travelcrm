# -*coding: utf-8-*-

import pkg_resources
import json

from webhelpers.html import tags
from webhelpers.html import HTML
from webhelpers.misc import NotGiven

from ..utils.common_utils import (
    gen_id as u_gen_id,
    get_company_name as u_get_company_name
)


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
    return json.dumps(val)


def get_company_name():
    return u_get_company_name()
