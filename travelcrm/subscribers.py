# -*-coding: utf-8 -*-

from pyramid.renderers import get_renderer
from pyramid.i18n import get_localizer, TranslationStringFactory

import lib.helpers as h


tsf = TranslationStringFactory('travelcrm')


def localizer(event):
    request = event.request
    localizer = get_localizer(request)

    def auto_translate(*args, **kwargs):
        return localizer.translate(tsf(*args, **kwargs))
    request.translate = auto_translate


def helpers(event):
    request = event['request']
    event.update({'h': h, '_': request.translate})
