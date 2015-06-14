# -*coding: utf-8-*-

from sqlalchemy import literal, or_

from . import (
    ResourcesQueryBuilder,
    query_row_serialize_format
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.navigation import Navigation


class NavigationsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(NavigationsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Navigation.id,
            '_id': Navigation.id,
            'name': Navigation.name,
            'text': Navigation.name,
            'sort_order': Navigation.sort_order,
            'icon_cls': Navigation.icon_cls,
            'parent_id': Navigation.parent_id.label('parent_id')
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        navigations_subquery = (
            DBSession.query(
                Navigation.parent_id,
                literal(u'closed').label('state')
            )
            .group_by(Navigation.parent_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(Navigation, Resource.navigation)
            .outerjoin(
                navigations_subquery,
                navigations_subquery.c.parent_id == Navigation.id
            )
        )
        self.update_fields({'state': navigations_subquery.c.state})
        super(NavigationsQueryBuilder, self).build_query()

    def filter_parent_id(self, parent_id, with_chain=False):
        if with_chain:
            chain = self._get_chain(parent_id)
            conditions = [
                Navigation.parent_id == item for item in chain
            ]
            conditions.append(Navigation.condition_root_level())
            self.query = self.query.filter(or_(*conditions))
        else:
            self.query = self.query.filter(
                Navigation.condition_parent_id(parent_id)
            )

    def filter_position_id(self, position_id):
        self.query = self.query.filter(
            Navigation.condition_position_id(
                position_id
            )
        )

    def _get_chain(self, id):
        chain = []
        if id:
            navigation = Navigation.get(id)
            while True:
                if navigation.parent_id:
                    chain.append(navigation.parent_id)
                    navigation = Navigation.get(
                        navigation.parent_id
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
