# -*coding: utf-8-*-

from sqlalchemy import MetaData
from sqlalchemy.schema import CreateSchema

from ...models import DBSession, Base
from ..utils.sql_utils import set_search_path
from ..utils.common_utils import gen_id


def create_company_schema(schema_name=None):
    if not schema_name:
        schema_name = generate_company_schema()
    engine = DBSession.get_bind()
    engine.execute(CreateSchema(schema_name))
    set_search_path(schema_name)
    metadata = MetaData(schema=schema_name)
    metadata.bind = engine
    Base.metadata.create_all(
        tables=[t.tometadata(metadata) for t in Base.metadata.sorted_tables]
    )


def generate_company_schema():
    return gen_id('c_')
