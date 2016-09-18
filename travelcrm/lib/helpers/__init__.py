# -*-coding: utf-8-*-
import json

import common
import fields
import permisions
import employees
import structures
from webhelpers2 import text
from webhelpers2.html import tags
from webhelpers2.html import builder


def title(title, required=False, label_for=None):
    """ label helper
    """
    title_html = title
    if label_for:
        title_html = builder.HTML.label(title_html, for_=label_for)
    if required:
        required_symbol = builder.HTML.span("*", class_="required-symbol")
        return builder.HTML.span(
            title_html, 
            " ",
            required_symbol,
            class_="required")
    else:
        return builder.HTML.span(title_html, class_="not-required")

tags.title = title
