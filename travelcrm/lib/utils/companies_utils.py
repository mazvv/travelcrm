# -*coding: utf-8-*-

from sqlalchemy.schema import CreateSchema

from ...models import DBSession, Base
from ..utils.sql_utils import (
    get_schemas,
    set_search_path
)


def create_company_schema(schema_name=None):
    if not schema_name:
        schema_name = generate_company_schema()
    DBSession.execute(CreateSchema(schema_name))
    set_search_path(schema_name)
    Base.metadata.create_all()


def generate_company_schema():
    schemas = get_schemas()
    return "c_%d" % len(schemas)
