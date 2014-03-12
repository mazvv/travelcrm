# -*coding: utf-8-*-

from collections import OrderedDict

from sqlalchemy.orm import class_mapper
from sqlalchemy.orm.properties import RelationshipProperty

from . import ResourcesQueryBuilder

from ...models.resource import Resource
from ...models.licence import Licence


class LicencesQueryBuilder(ResourcesQueryBuilder):

    _fields = OrderedDict({
        'id': Licence.id,
        '_id': Licence.id,
        'licence_num': Licence.licence_num,
        'date_from': Licence.date_from,
        'date_to': Licence.date_to,
    })

    _simple_search_fields = [
        Licence.licence_num
    ]

    def __init__(self, context):
        super(LicencesQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Licence, Resource.licence)
        self.query = self.query.add_columns(*fields)

    def filter_reference(self, ref_name, ref_id):
        for item in class_mapper(Licence).iterate_properties:
            if isinstance(item, RelationshipProperty) and item.key == ref_name:
                ref_cls = item.mapper.class_
                self.query = (
                    self.query
                    .join(ref_cls, getattr(Licence, ref_name))
                    .filter(ref_cls.id == ref_id)
                )
                return
        raise ValueError(
            u"Can't find given ref_name %{ref_name}".format(ref_name)
        )

    def filter_id(self, ids):
        assert isinstance(ids, (str, unicode)) or ids is None
        if ids:
            self.query = self.query.filter(Licence.id.in_(ids.split(',')))
