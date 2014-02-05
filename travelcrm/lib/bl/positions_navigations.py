# -*coding: utf-8-*-

from sqlalchemy import func

from ...models import DBSession
from ...models.position_navigation import PositionNavigation


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
