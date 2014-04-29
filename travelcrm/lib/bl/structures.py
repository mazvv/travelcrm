# -*coding: utf-8-*-

from sqlalchemy import cast, Integer, Text, func
from sqlalchemy.dialects.postgresql import array
from sqlalchemy.orm import aliased

from ...models import DBSession
from ...models.structure import Structure


def query_recursive_tree():
    structure_tree = (
        DBSession.query(
            Structure.id,
            Structure.name,
            Structure.parent_id,
            cast(1, Integer()).label('depth'),
            array([cast(Structure.name, Text)]).label('name_path'),
            array([Structure.id]).label('path'),
        )
        .filter(Structure.condition_root_level())
        .cte(name='structure_tree', recursive=True)
    )
    st = aliased(structure_tree, name='st')
    s = aliased(Structure, name='s')
    structure_tree = structure_tree.union_all(
        DBSession.query(
            s.id, s.name, s.parent_id,
            (st.c.depth + 1).label('depth'),
            func.array_append(
                st.c.name_path, cast(s.name, Text)
            ).label('name_path'),
            func.array_append(st.c.path, s.id).label('path'),
        )
        .filter(s.parent_id == st.c.id)
    )
    return DBSession.query(structure_tree)


def get_structure_name_path(structure):
    assert isinstance(structure, Structure), u'Must be Structure instance'
    subq = query_recursive_tree().subquery()
    path = (
        DBSession.query(subq.c.name_path)
        .filter(subq.c.id == structure.id)
        .scalar()
    )
    if path:
        return path
