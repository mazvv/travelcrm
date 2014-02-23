# -*coding: utf-8-*-

from whoosh.fields import (
    Schema,
    TEXT,
    ID,
    NUMERIC,
)

from ..search import get_index


schema = Schema(
    id=ID(stored=True, unique=True),
    iso_code=TEXT(stored=False),
    owner_structure=TEXT(stored=False),
    status=NUMERIC(stored=False),
)


def get_currency_index():
    return get_index('currency', schema)
