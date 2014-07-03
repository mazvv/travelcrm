# -*coding: utf-8-*-

import random
from uuid import uuid4

from babel.dates import format_date as fd, format_datetime as fdt
from babel.dates import parse_date as pd
from babel.numbers import format_decimal as fdc

from pyramid.threadlocal import get_current_registry
from pyramid.threadlocal import get_current_request
from pyramid.interfaces import ITranslationDirectories

from pyramid.i18n import make_localizer, get_localizer

from sqlalchemy import cast, Numeric


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


def is_demo_mode():
    val = _get_settings_value('company.demo_mode')
    return val == 'true'

   
def _get_localizer_for_locale_name(locale_name):
    registry = get_current_registry()
    tdirs = registry.queryUtility(ITranslationDirectories, default=[])
    return make_localizer(locale_name, tdirs)


def translate(*args, **kwargs):
    request = get_current_request()
    if request is None:
        localizer = _get_localizer_for_locale_name('en')
    else:
        localizer = get_localizer(request)
    return localizer.translate(*args, **kwargs)


def cast_int(val):
    try:
        return int(val)
    except ValueError:
        return None


def get_company_name():
    return _get_settings_value('company.name')


def get_base_currency():
    return _get_settings_value('company.base_currency')


def money_cast(attr):
    return cast(attr, Numeric(16, 2))


def format_date(value):
    return fd(
        value, format="short", locale=get_locale_name()
    )


def format_datetime(value):
    return fdt(
        value, format="short", locale=get_locale_name()
    )


def format_decimal(value):
    return fdc(value, locale=get_locale_name())


def parse_date(value):
    return pd(value, locale=get_locale_name())
