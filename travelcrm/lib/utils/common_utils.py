# -*coding: utf-8-*-

from pyramid.threadlocal import get_current_registry


def _get_settings_value(name):
    registry = get_current_registry()
    settings = registry.settings
    return settings.get(name)


def get_locale_name():
    return _get_settings_value('pyramid.default_locale_name')


def get_whoosh_path():
    return _get_settings_value('whoosh.index_path')
