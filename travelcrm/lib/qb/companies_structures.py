# -*coding: utf-8-*-

from sqlalchemy import literal, or_

from . import (
    ResourcesQueryBuilder,
    query_row_serialize_format
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.company_struct import CompanyStruct


class CompaniesStructuresQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': CompanyStruct.id,
        '_id': CompanyStruct.id,
        'struct_name': CompanyStruct.name,
        'text': CompanyStruct.name,
        'parent_id': CompanyStruct.parent_id.label('parent_id')
    }

    def __init__(self):
        super(CompaniesStructuresQueryBuilder, self).__init__()
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        structs_subquery = (
            DBSession.query(
                CompanyStruct.parent_id,
                literal(u'closed').label('state')
            )
            .group_by(CompanyStruct.parent_id)
            .subquery()
        )

        self.query = (
            self.query
            .join(CompanyStruct, Resource.company_struct)
            .outerjoin(
                structs_subquery,
                structs_subquery.c.parent_id == CompanyStruct.id
            )
        )
        fields.append(structs_subquery.c.state)
        self.query = self.query.add_columns(*fields)

    def filter_parent_id(self, parent_id, with_chain=False):
        if with_chain:
            chain = self._get_chain(parent_id)
            conditions = [
                CompanyStruct.parent_id == item for item in chain
            ]
            conditions.append(CompanyStruct.condition_root_level())
            self.query = self.query.filter(or_(*conditions))
        else:
            self.query = self.query.filter(
                CompanyStruct.condition_parent_id(parent_id)
            )

    def filter_company_id(self, companies_id):
        self.query = self.query.filter(
            CompanyStruct.condition_company_id(companies_id)
        )

    def _get_chain(self, id):
        chain = []
        if id:
            company_struct = CompanyStruct.get(id)
            while True:
                if company_struct.parent_id:
                    chain.append(company_struct.parent_id)
                    company_struct = CompanyStruct.get(
                        company_struct.parent_id
                    )
                else:
                    break
        return chain

    def get_serialized(self):
        structures = {}
        root_parent_id = False

        for item in self.query:
            item_children = structures.setdefault(item.parent_id, [])
            item_children.append(item)
            structures[item.parent_id] = item_children
            if root_parent_id is False:
                root_parent_id = item.parent_id
            elif root_parent_id == item.id:
                root_parent_id = item.parent_id

        def tree(row):
            res_row = query_row_serialize_format(row)
            if structures.get(row.id):
                res_row['children'] = [
                    tree(item)
                    for item
                    in structures.get(row.id)
                ]
            return res_row

        if structures.get(root_parent_id):
            return [tree(row) for row in structures.get(root_parent_id)]
        return []
