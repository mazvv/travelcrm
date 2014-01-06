# -*coding: utf-8-*-

import pkg_resources
from uuid import uuid4

from webhelpers import html


def get_package_version(package_name):
    version = u'<uknown>'
    try:
        version = pkg_resources.get_distribution(package_name).version
    finally:
        return version


def get_oid(prefix=None):
    if not prefix:
        prefix = u'obj'
    return "{prefix}-{uuid}".format(prefix=prefix, uuid=str(uuid4()))
