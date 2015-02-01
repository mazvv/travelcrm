# -*coding: utf-8-*-

from collections import Iterable


def build_union_query(queries):
    assert isinstance(queries, Iterable)

    if not queries:
        return None
    elif len(queries) == 1:
        return queries[0]
    else:
        return queries[0].union(*queries[1:])
