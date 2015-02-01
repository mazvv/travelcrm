# -*coding: utf-8-*-

from sqlalchemy import literal, or_

from . import (
    ResourcesQueryBuilder,
    query_row_serialize_format
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.structure import Structure


class StructuresQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(StructuresQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Structure.id,
            '_id': Structure.id,
            'structure_name': Structure.name,
            'text': Structure.name,
            'parent_id': Structure.parent_id.label('parent_id')
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        structs_subquery = (
            DBSession.query(
                Structure.parent_id,
                literal(u'closed').label('state')
            )
            .group_by(Structure.parent_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(Structure, Resource.structure)
            .outerjoin(
                structs_subquery,
                structs_subquery.c.parent_id == Structure.id
            )
        )
        self.update_fields({'state': structs_subquery.c.state})
        super(StructuresQueryBuilder, self).build_query()

    def filter_parent_id(self, parent_id, with_chain=False):
        if with_chain:
            chain = self._get_chain(parent_id)
            conditions = [
                Structure.parent_id == item for item in chain
            ]
            conditions.append(Structure.condition_root_level())
            self.query = self.query.filter(or_(*conditions))
        else:
            self.query = self.query.filter(
                Structure.condition_parent_id(parent_id)
            )

    def _get_chain(self, id):
        chain = []
        if id:
            structure = Structure.get(id)
            while True:
                if structure.parent_id:
                    chain.append(structure.parent_id)
                    structure = Structure.get(
                        structure.parent_id
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
