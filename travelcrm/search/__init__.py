# -*-coding: utf-8-*-

from whoosh.index import (
    exists_in,
    create_in,
    open_dir
)

from ..lib.utils.common_utils import get_whoosh_path


class WhooshPathNotImplemented(Exception):
    pass


def get_index(indexname, schema):
    index_path = get_whoosh_path()
    if not index_path:
        raise WhooshPathNotImplemented()

    if not exists_in(index_path, indexname):
        ix = create_in(index_path, schema, indexname)
    else:
        ix = open_dir(index_path, indexname)
    return ix
