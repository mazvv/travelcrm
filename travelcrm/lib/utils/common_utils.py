# -*coding: utf-8-*-

import random
from uuid import uuid4
from datetime import datetime
from decimal import Decimal, ROUND_DOWN

from babel.dates import (
    format_date as fd, format_datetime as fdt, format_time as ft
)
from babel.dates import parse_date as pd, parse_time as pt
from babel.numbers import format_decimal as fdc

from pyramid.threadlocal import get_current_registry
from pyramid.threadlocal import get_current_request
from pyramid.interfaces import ITranslationDirectories

from pyramid.i18n import (
    make_localizer,
    get_localizer,
    TranslationStringFactory
)

from sqlalchemy import cast, Numeric

from ...interfaces import IScheduler

tsf = TranslationStringFactory('travelcrm')


def _get_settings_value(name):
    settings = get_settings()
    return settings.get(name)


def get_settings():
    registry = get_current_registry()
    return registry.settings


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
    return localizer.translate(tsf(*args, **kwargs))


def cast_int(val):
    try:
        return int(val)
    except ValueError:
        return None


def get_company_name():
    return _get_settings_value('company.name')


def get_base_currency():
    return _get_settings_value('company.base_currency')


def get_date_format():
    return _get_settings_value('date.format')


def get_datetime_format():
    return _get_settings_value('datetime.format')


def get_time_format():
    return _get_settings_value('time.format')


def get_first_day():
    return _get_settings_value('date.first_day')


def get_date_js_format():
    return _get_settings_value('date.js_format')


def get_datetime_js_format():
    return _get_settings_value('datetime.js_format')


def money_cast(attr):
    if isinstance(attr, (Decimal, int, float)):
        return Decimal(attr).quantize(Decimal('.01'), rounding=ROUND_DOWN)
    return cast(attr, Numeric(16, 2))


def format_date(value):
    return fd(
        value, format=get_date_format(), locale=get_locale_name()
    )


def format_datetime(value):
    return fdt(
        value, format=get_datetime_format(), locale=get_locale_name()
    )


def format_time(value):
    return ft(
        value, format=get_time_format(), locale=get_locale_name()
    )


def format_decimal(value):
    return fdc(value, locale=get_locale_name())


def parse_date(value):
    return pd(value, locale=get_locale_name())


def parse_datetime(value):
    d = pd(value, locale=get_locale_name())

    # TODO: rework this
    time_str = value.split(' ')[1]
    value = time_str.strip()
    value = "%s:00" % value
    t = pt(value, locale=get_locale_name())
    return datetime.combine(d, t)


def get_scheduler(request):
    registry = getattr(request, 'registry', None)
    if registry is None:
        registry = request
    return registry.getUtility(IScheduler)
