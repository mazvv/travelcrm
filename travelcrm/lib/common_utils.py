# -*coding: utf-8-*-

from pyramid.threadlocal import get_current_registry


def get_locale_name():
    registry = get_current_registry()
    settings = registry.settings
    return settings.get('pyramid.default_locale_name')
