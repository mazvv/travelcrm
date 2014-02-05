# -*coding: utf-8-*-

from sqlalchemy import func

from . import ResourcesQueryBuilder
from ...models import DBSession
from ...models.resource import Resource
from ...models.company import Company
from ...models.company_struct import CompanyStruct


class CompaniesQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Company.id,
        '_id': Company.id,
        'company_name': Company.name,
    }

    def __init__(self):
        super(CompaniesQueryBuilder, self).__init__()
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Company, Resource.company)
        self.query = self.query.add_columns(*fields)

    def structs_quan_query(self):
        subq = (
            DBSession.query(
                CompanyStruct.companies_id,
                func.count(CompanyStruct.id).label('structs_quan')
            )
            .group_by(CompanyStruct.companies_id)
            .subquery()
        )
        self.query = self.query.outerjoin(
            subq, subq.c.companies_id == Company.id
        )
        self.query = self.query.add_columns(subq.c.structs_quan)

