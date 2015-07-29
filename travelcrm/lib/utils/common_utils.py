# -*coding: utf-8-*-

import random
from uuid import uuid4
from datetime import datetime, date, time
from decimal import Decimal

from pytz import timezone
from dateutil.parser import parse as pdt
from babel.dates import (
    format_date as fd, 
    format_datetime as fdt, 
    format_time as ft,
    get_date_format as gdf,
    get_time_format as gtf,
    get_datetime_format as gdtf,
)
from babel.numbers import (
    format_decimal as fdc,
    format_currency as fc
)

from pyramid.threadlocal import get_current_registry
from pyramid.threadlocal import get_current_request
from pyramid.interfaces import ITranslationDirectories

from pyramid.i18n import (
    make_localizer,
    TranslationStringFactory
)

from ...interfaces import IScheduler


DEFAULT_LOCALE_NAME = 'en'

tsf = TranslationStringFactory('travelcrm')


def _get_settings_value(name):
    settings = get_settings()
    return settings.get(name)


def get_settings():
    registry = get_current_registry()
    return registry.settings


def get_locale_name():
    settings = get_settings()
    return settings.get('company.locale_name') 


def get_timezone():
    settings = get_settings()
    return settings.get('company.timezone') 


def _get_localizer_for_locale_name(locale_name):
    registry = get_current_registry()
    tdirs = registry.queryUtility(ITranslationDirectories, default=[])
    return make_localizer(locale_name, tdirs)


def translate(*args, **kwargs):
    request = get_current_request()
    if request is None:
        localizer = _get_localizer_for_locale_name(DEFAULT_LOCALE_NAME)
    else:
        locale_name = get_locale_name()
        localizer = _get_localizer_for_locale_name(locale_name)
    return localizer.translate(tsf(*args, **kwargs))


def gen_id(prefix='', limit=6):
    s = list(str(int(uuid4())))
    random.shuffle(s)
    return u"%s%s" % (prefix, ''.join(s[:limit]))


def cast_int(val):
    try:
        return int(val)
    except ValueError:
        return None


def get_company_name():
    settings = get_settings()
    return settings.get('company.name', '') 


def get_base_currency():
    settings = get_settings()
    return settings.get('company.base_currency') 


def get_date_format():
    return gdf(format='short', locale=get_locale_name()).pattern


def get_time_format():
    return gtf(format='short', locale=get_locale_name()).pattern


def get_datetime_format():
    f = gdtf(format='short', locale=get_locale_name())
    return f.format(get_time_format(), get_date_format())


def parse_datetime(s):
    return timezone(get_timezone()).localize(pdt(s))


def format_date(value):
    return fd(
        value, format='short', locale=get_locale_name()
    )


def format_datetime(value):
    return fdt(
        value, format=get_datetime_format(), 
        locale=get_locale_name(), tzinfo=timezone(get_timezone())
    )


def format_time(value):
    return ft(
        value, format=get_time_format(), locale=get_locale_name()
    )


def format_decimal(value, quantize='.01'):
    value = Decimal(value).quantize(Decimal(quantize))
    return fdc(value, locale=get_locale_name())


def get_scheduler(request):
    registry = getattr(request, 'registry', None)
    if registry is None:
        registry = request
    return registry.getUtility(IScheduler)


def serialize(value):
    if isinstance(value, datetime):
        return format_datetime(value)
    if isinstance(value, date):
        return format_date(value)
    if isinstance(value, time):
        return format_time(value)
    if isinstance(value, Decimal):
        return format_decimal(value)
    if hasattr(value, 'serialize'):
        return value.serialize()
    return value


def format_currency(value, currency):
    return fc(value, currency, locale=get_locale_name())


def get_storage_dir():
    dt = datetime.now(tz=timezone(get_timezone()))
    return "%d%d%d" % (dt.year, dt.month, dt.day)


def get_storage_max_size():
    settings = get_settings()
    return settings.get('storage.max_size')


def get_public_domain():
    settings = get_settings()
    return settings.get('public_domain')


def get_public_subdomain():
    settings = get_settings()
    return settings.get('public_subdomain')

    
def get_multicompanies():
    settings = get_settings()
    return int(settings.get('multicompanies'))

    