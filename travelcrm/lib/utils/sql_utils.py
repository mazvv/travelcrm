# -*coding: utf-8-*-

from collections import Iterable
from sqlalchemy import inspect

from ...models import DBSession


def build_union_query(queries):
    assert isinstance(queries, Iterable)

    if not queries:
        return None
    elif len(queries) == 1:
        return queries[0]
    else:
        return queries[0].union(*queries[1:])


def get_schemas():
    engine = DBSession.get_bind()
    insp = inspect(engine)
    return insp.get_schema_names()


def get_default_schema():
    engine = DBSession.get_bind()
    insp = inspect(engine)
    return insp.default_schema_name


def set_search_path(*args):
    DBSession.execute('set search_path to %s' % (', '.join(args)))


def get_current_schema():
    return DBSession.execute('select current_schema()').scalar()


def get_all_schema_sequences(schema):
    query = DBSession.execute('''
        select c.relname AS sequencename
        from pg_class c 
        left join pg_catalog.pg_namespace n ON n.oid = c.relnamespace
        where (c.relkind = 'S' and n.nspname = '%s');
    ''' % schema)
    return [item[0] for item in query]
        