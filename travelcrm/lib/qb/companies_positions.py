# -*coding: utf-8-*-

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.company_position import CompanyPosition


class CompaniesPositionsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': CompanyPosition.id,
        '_id': CompanyPosition.id,
        'position_name': CompanyPosition.name,
    }

    def __init__(self, context):
        super(CompaniesPositionsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(
            CompanyPosition, Resource.company_position
        )
        self.query = self.query.add_columns(*fields)

    def filter_structure_id(self, structure_id):
        self.query = self.query.filter(
            CompanyPosition.condition_structure_id(structure_id)
        )
