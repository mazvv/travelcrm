# -*coding: utf-8-*-

from sqlalchemy import literal, or_, func

from . import (
    ResourcesQueryBuilder,
    query_row_serialize_format
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.position_navigation import PositionNavigation


class PositionsNavigationsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': PositionNavigation.id,
        '_id': PositionNavigation.id,
        'name': PositionNavigation.name,
        'text': PositionNavigation.name,
        'position': PositionNavigation.position,
        'icon_cls': PositionNavigation.icon_cls,
        'parent_id': PositionNavigation.parent_id.label('parent_id')
    }

    def __init__(self):
        super(PositionsNavigationsQueryBuilder, self).__init__()
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        navigations_subquery = (
            DBSession.query(
                PositionNavigation.parent_id,
                literal(u'closed').label('state')
            )
            .group_by(PositionNavigation.parent_id)
            .subquery()
        )

        self.query = (
            self.query
            .join(PositionNavigation, Resource.position_navigation)
            .outerjoin(
                navigations_subquery,
                navigations_subquery.c.parent_id == PositionNavigation.id
            )
        )
        fields.append(navigations_subquery.c.state)
        self.query = self.query.add_columns(*fields)

    def filter_parent_id(self, parent_id, with_chain=False):
        if with_chain:
            chain = self._get_chain(parent_id)
            conditions = [
                PositionNavigation.parent_id == item for item in chain
            ]
            conditions.append(PositionNavigation.condition_root_level())
            self.query = self.query.filter(or_(*conditions))
        else:
            self.query = self.query.filter(
                PositionNavigation.condition_parent_id(parent_id)
            )

    def filter_company_position_id(self, companies_positions_id):
        self.query = self.query.filter(
            PositionNavigation.condition_company_position_id(
                companies_positions_id
            )
        )

    def _get_chain(self, id):
        chain = []
        if id:
            position_navigation = PositionNavigation.get(id)
            while True:
                if position_navigation.parent_id:
                    chain.append(position_navigation.parent_id)
                    position_navigation = PositionNavigation.get(
                        position_navigation.parent_id
                    )
                else:
                    break
        return chain

    def get_serialized(self):
        navigations = {}
        root_parent_id = False

        for item in self.query:
            item_children = navigations.setdefault(item.parent_id, [])
            item_children.append(item)
            navigations[item.parent_id] = item_children
            if root_parent_id is False:
                root_parent_id = item.parent_id
            elif root_parent_id == item.id:
                root_parent_id = item.parent_id

        def tree(row):
            res_row = query_row_serialize_format(row)
            if navigations.get(row.id):
                res_row['children'] = [
                    tree(item)
                    for item
                    in navigations.get(row.id)
                ]
            return res_row

        if navigations.get(root_parent_id):
            return [tree(row) for row in navigations.get(root_parent_id)]
        return []


def get_next_position(companies_positions_id, parent_id):
    navigations_quan = (
        DBSession.query(func.count(PositionNavigation.id)).filter(
            PositionNavigation.condition_parent_id(parent_id),
            PositionNavigation.condition_company_position_id(
                companies_positions_id
            )
        )
        .scalar()
    )
    return navigations_quan + 1
