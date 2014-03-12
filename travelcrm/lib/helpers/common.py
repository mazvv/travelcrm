# -*coding: utf-8-*-

import pkg_resources

from webhelpers.html import tags
from webhelpers.html import HTML
from webhelpers.misc import NotGiven

from ..utils.common_utils import gen_id as u_gen_id


def reset(name, value=None, id=NotGiven, **attrs):
    return tags.text(name, value, id, type="reset", **attrs)


def get_package_version(package_name):
    version = u'<uknown>'
    try:
        version = pkg_resources.get_distribution(package_name).version
    finally:
        return version


def error_container(name):
    return HTML.tag(
        'span', 
        class_='error fa fa-exclamation-circle hidden', 
        **{'data-name': name}
    )


def gen_id(limit=6):
    return u_gen_id(limit)
