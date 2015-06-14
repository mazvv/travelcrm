# -*coding: utf-8-*-

from sqlalchemy import literal, or_

from . import (
    ResourcesQueryBuilder,
    query_row_serialize_format
)
from ...models import DBSession
from ...models.resource import Resource
from ...models.account_item import AccountItem


class AccountsItemsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(AccountsItemsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': AccountItem.id,
            '_id': AccountItem.id,
            'name': AccountItem.name,
            'text': AccountItem.name,
            'type': AccountItem.type,
            'status': AccountItem.status,
            'parent_id': AccountItem.parent_id.label('parent_id')
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        accounts_items_subquery = (
            DBSession.query(
                AccountItem.parent_id,
                literal(u'closed').label('state')
            )
            .group_by(AccountItem.parent_id)
            .subquery()
        )
        self.query = (
            self.query
            .join(AccountItem, Resource.account_item)
            .outerjoin(
                accounts_items_subquery,
                accounts_items_subquery.c.parent_id == AccountItem.id
            )
        )
        self.update_fields({'state': accounts_items_subquery.c.state})
        super(AccountsItemsQueryBuilder, self).build_query()

    def filter_parent_id(self, parent_id, with_chain=False):
        if with_chain:
            chain = self._get_chain(parent_id)
            conditions = [
                AccountItem.parent_id == item for item in chain
            ]
            conditions.append(AccountItem.condition_root_level())
            self.query = self.query.filter(or_(*conditions))
        else:
            self.query = self.query.filter(
                AccountItem.condition_parent_id(parent_id)
            )

    def _get_chain(self, id):
        chain = []
        if id:
            account_item = AccountItem.get(id)
            while True:
                if account_item.parent_id:
                    chain.append(account_item.parent_id)
                    account_item = AccountItem.get(
                        account_item.parent_id
                    )
                else:
                    break
        return chain

    def get_serialized(self):
        accounts_items = {}
        root_parent_id = False

        for item in self.query:
            item_children = accounts_items.setdefault(item.parent_id, [])
            item_children.append(item)
            accounts_items[item.parent_id] = item_children
            if root_parent_id is False:
                root_parent_id = item.parent_id
            elif root_parent_id == item.id:
                root_parent_id = item.parent_id

        def tree(row):
            res_row = query_row_serialize_format(row)
            if accounts_items.get(row.id):
                res_row['children'] = [
                    tree(item)
                    for item
                    in accounts_items.get(row.id)
                ]
            return res_row

        if accounts_items.get(root_parent_id):
            return [tree(row) for row in accounts_items.get(root_parent_id)]
        return []
