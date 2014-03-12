# -*-coding: utf-8-*-
import json

import common
import fields
from webhelpers.html import tags
from webhelpers.html import builder
from webhelpers import util


# need it to possibility use of data-options
def attr_decode():
    from webhelpers.html.builder import _attr_decode

    def _helpers_attr_decode(v):
        if v == 'data_options':
            return 'data-options'
        return _attr_decode(v)
    return _helpers_attr_decode

builder._attr_decode = attr_decode()
