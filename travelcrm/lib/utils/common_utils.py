# -*coding: utf-8-*-

import random
from uuid import uuid4

from pyramid.threadlocal import (
    get_current_registry,
    get_current_request
)


def _get_settings_value(name):
    registry = get_current_registry()
    settings = registry.settings
    return settings.get(name)


def get_locale_name():
    return _get_settings_value('pyramid.default_locale_name')


def gen_id(prefix='', limit=6):
    s = list(str(int(uuid4())))
    random.shuffle(s)
    return u"%s%s" % (prefix, ''.join(s[:limit]))


def get_translate():
    request = get_current_request()
    return request.translate
