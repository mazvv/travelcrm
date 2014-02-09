# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.navigation import Navigation


def get_next_position(position_id, parent_id):
    navigations_quan = (
        DBSession.query(func.count(Navigation.id)).filter(
            Navigation.condition_parent_id(parent_id),
            Navigation.condition_position_id(position_id)
        )
        .scalar()
    )
    return navigations_quan + 1
