# -*coding: utf-8-*-

import logging

from sqlalchemy import MetaData, Sequence
from sqlalchemy.schema import CreateSchema

from ...models import DBSession, Base
from ...models.company import Company
from ...models.user import User
from ...lib import EnumInt
from ..utils.sql_utils import (
    set_search_path,
    get_current_schema,
    get_all_schema_sequences
)
from ..utils.common_utils import (
    get_public_domain as u_get_public_domain, 
    get_public_subdomain,
    get_multicompanies,
    gen_id
)


log = logging.getLogger(__name__)

SOURCE_SCHEMA = 'company'
SEQUENCE_NAME = 'companies_counter'
TABLES = (
    'appointment', 'company', 'country', 'currency', 'employee', 
    'navigation', 'permision', 'resource', 'position',
    'resource_type', 'service', 'structure', 'user'
)


def create_company_schema(schema_name=None, locale=None):
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
    transfer_data(schema_name, locale)
    log.info(u'Company creation complete')
    return schema_name


def generate_company_schema():
    sequence = Sequence(SEQUENCE_NAME)
    return 'c%d' % DBSession.execute(sequence.next_value()).scalar()


def transfer_data(schema_name, locale=None):
    source_schema = (
        SOURCE_SCHEMA
        if not locale 
        else SOURCE_SCHEMA + '_' +locale
    )
    set_search_path(source_schema)
    tables = Base.metadata.sorted_tables

    for table in tables:
        set_search_path(source_schema)
        rows = DBSession.query(table).all()
        set_search_path(schema_name)
        DBSession.execute('alter table "%s" disable trigger all' % table.name)
        if table.name not in TABLES:
            continue
        for row in rows:
            row = map(
                lambda x: ((x.key or None) if isinstance(x, EnumInt) else x), row
            )
            DBSession.execute(table.insert(row))
            
    set_search_path(schema_name)
    sequences = get_all_schema_sequences(schema_name)
    for table in tables:
        if '%s_id_seq' % table.name in sequences:
            max_id = DBSession.execute(
                'select max(id) from "%s"' % table.name
            ).first()
            DBSession.execute(
                "select setval('%s_id_seq', %s)"
                % (table.name, max_id[0] or 1)
            )
        DBSession.execute('alter table "%s" enable trigger all' % table.name)

    # set new users passwords
    users = DBSession.query(User).all()
    for user in users:
        user.password = gen_id()


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


def get_company():
    return DBSession.query(Company).first()
