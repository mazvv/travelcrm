# -*coding: utf-8-*-

import logging

from sqlalchemy import MetaData, Sequence
from sqlalchemy.schema import CreateSchema

from ...models import DBSession, Base
from ..utils.sql_utils import set_search_path, get_current_schema
from ..utils.common_utils import (
    get_public_domain as u_get_public_domain, 
    get_public_subdomain,
    get_multicompanies,
)


log = logging.getLogger(__name__)

SOURCE_SCHEMA = 'public'
SEQUENCE_NAME = 'companies_counter'


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
    transfer_data(schema_name)
    log.info(u'Company creation complete')
    return schema_name


def generate_company_schema():
    sequence = Sequence(SEQUENCE_NAME)
    return 'c%d' % DBSession.execute(sequence.next_value()).scalar()


def transfer_data(schema_name):
    set_search_path(SOURCE_SCHEMA)
    tables = Base.metadata.sorted_tables
    for table in tables:
        set_search_path(SOURCE_SCHEMA)
        rows = DBSession.query(table).all()
        set_search_path(schema_name)
        DBSession.execute('alter table "%s" disable trigger all' % table.name)
        for row in rows:
            DBSession.execute(table.insert(row))
    set_search_path(schema_name)
    for table in tables:
        DBSession.execute('alter table "%s" enable trigger all' % table.name)


def get_public_domain():
    domain = u_get_public_domain()
    subdomain = get_public_subdomain()
    if subdomain:
        return '%s.%s' % (subdomain, domain)
    return domain


def get_company_url(request, schema_name=None):
    public_domain = u_get_public_domain()
    if schema_name is None:
        if request.domain == get_public_domain():
            return '%s://%s' % (request.scheme, get_public_domain())
        else:
            schema_name = get_current_schema()
    return "%s://%s.%s" % (request.scheme, schema_name, public_domain)


def can_create_company(request):
    return get_multicompanies() and get_public_domain() == request.domain
