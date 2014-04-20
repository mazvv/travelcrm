# -*-coding: utf-8 -*-

import lib.helpers as h
from .lib.utils.common_utils import translate as _


def helpers(event):
    event.update({'h': h, '_': _})
