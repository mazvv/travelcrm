# -*coding: utf-8-*-

from sqlalchemy import func
from sqlalchemy.orm.session import make_transient

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


def copy_from_position(source_position_id, target_position_id):
    assert isinstance(source_position_id, int), \
        u"Integer expected"
    assert isinstance(target_position_id, int), \
        u"Integer expected"

    (
        DBSession.query(Navigation)
        .filter(
            Navigation.condition_position_id(target_position_id)
        )
        .delete()
    )
    navigations_from = (
        DBSession.query(Navigation)
        .filter(
            Navigation.condition_position_id(source_position_id)
        )
    )
    transform_map = []
    for navigation in navigations_from:
        make_transient(navigation)
        old_id = navigation.id
        navigation.id = None
        navigation.position_id = target_position_id
        DBSession.add(navigation)
        DBSession.flush([navigation, ])
        transform_map.append((old_id, navigation.id))

    target_navigations = (
        DBSession.query(Navigation)
        .filter(
            Navigation.condition_position_id(target_position_id)
        )
    )
    for navigation in target_navigations:
        navigation.parent_id = dict(transform_map).get(navigation.parent_id)
    return
