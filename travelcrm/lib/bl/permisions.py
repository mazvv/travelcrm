# -*coding: utf-8-*-

from sqlalchemy.orm.session import make_transient

from ...models import DBSession
from ...models.permision import Permision


def copy_from_position(source_position_id, target_position_id):
    assert isinstance(source_position_id, int), \
        u"Integer expected"
    assert isinstance(target_position_id, int), \
        u"Integer expected"

    (
        DBSession.query(Permision)
        .filter(
            Permision.condition_position_id(target_position_id)
        )
        .delete()
    )
    permisions_from = (
        DBSession.query(Permision)
        .filter(
            Permision.condition_position_id(source_position_id)
        )
    )
    for permision in permisions_from:
        make_transient(permision)
        permision.id = None
        permision.position_id = target_position_id
        DBSession.add(permision)
    return
