# -*coding: utf-8-*-

import random
from uuid import uuid4
from json import JSONEncoder, dumps
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
    parse_date as pd
)
from babel.numbers import (
    format_decimal as fdc,
    format_currency as fc
)

from pyramid.settings import asbool, aslist
from pyramid.threadlocal import get_current_registry
from pyramid.threadlocal import get_current_request
from pyramid.interfaces import ITranslationDirectories

from pyramid.i18n import (
    make_localizer,
    TranslationStringFactory
)

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


def get_default_locale_name():
    settings = get_settings() or {}
    return settings.get('pyramid.default_locale_name', DEFAULT_LOCALE_NAME) 


def get_available_locales():
    settings = get_settings()
    return aslist(settings.get('pyramid.available_languages')) 
    

def get_timezone():
    settings = get_settings()
    return settings.get('company.timezone') 


def _get_localizer_for_locale_name(locale_name):
    registry = get_current_registry()
    tdirs = registry.queryUtility(ITranslationDirectories, default=[])
    return make_localizer(locale_name, tdirs)


# class translate(object):
#     def __init__(self, *args, **kwargs):
#         self._args = args
#         self._kwargs = kwargs
# 
#     def __call__(self):
#         return _translate(*self._args, **self._kwargs)
# 
#     def __str__(self):
#         return self.__call__()
# 
#     def serialize(self):
#         return self.__call__()
#     
#     def __add__(self, other):
#         return self.__call__() + other
#  
#     def __radd__(self, other):
#         return other + self.__call__()


def translate(*args, **kwargs):
    request = get_current_request()
    if request is None:
        localizer = _get_localizer_for_locale_name(get_default_locale_name())
    else:
        locale_name = get_locale_name() or get_default_locale_name()
        localizer = _get_localizer_for_locale_name(locale_name)
    return localizer.translate(tsf(*args, **kwargs))


def gen_id(prefix='', limit=6):
    s = list(str(int(uuid4())))
    random.shuffle(s)
    return u"%s%s" % (prefix, ''.join(s[:limit]))


def cast_int(val):
    try:
        return int(val)
    except:
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


def parse_date(s):
    return pd(s, locale=get_locale_name())


def format_date(value, format=None):
    if not value:
        return ''
    return fd(
        value, format=(format or get_date_format()), locale=get_locale_name()
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
    return asbool(settings.get('multicompanies'))


def get_tarifs():
    settings = get_settings()
    return asbool(settings.get('tarifs.enabled'))


def get_tarifs_timeout():
    settings = get_settings()
    return asbool(settings.get('tarifs.timeout'))


class _JSONEncoder(JSONEncoder):
    def default(self, obj):
        return serialize(obj)


def jsonify(obj):
    return dumps(obj, cls=_JSONEncoder)
