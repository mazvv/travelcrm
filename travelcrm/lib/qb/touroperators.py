# -*coding: utf-8-*-

from . import ResourcesQueryBuilder
from .licences import LicencesQueryBuilder
from .bpersons import BPersonsQueryBuilder

from ...models.resource import Resource
from ...models.touroperator import Touroperator
from ...models.licence import Licence
from ...models.bperson import BPerson


class TouroperatorsQueryBuilder(ResourcesQueryBuilder):
    _fields = {
        'id': Touroperator.id,
        '_id': Touroperator.id,
        'name': Touroperator.name
    }

    _simple_search_fields = [
        Touroperator.name,
    ]

    def __init__(self, context):
        super(TouroperatorsQueryBuilder, self).__init__(context)
        fields = ResourcesQueryBuilder.get_fields_with_labels(
            self.get_fields()
        )
        self.query = self.query.join(Touroperator, Resource.touroperator)
        self.query = self.query.add_columns(*fields)

    def filter_id(self, id):
        if id:
            self.query = self.query.filter(Touroperator.id == id)


class TouroperatorsLicencesQueryBuilder(LicencesQueryBuilder):

    def filter_relation(self, touroperator_id):
        self.query = (
            self.query
            .join(Touroperator, Licence.touroperator)
            .filter(Touroperator.id == touroperator_id)
        )


class TouroperatorsBPersonsQueryBuilder(BPersonsQueryBuilder):

    def filter_relation(self, touroperator_id):
        self.query = (
            self.query
            .join(Touroperator, BPerson.touroperator)
            .filter(Touroperator.id == touroperator_id)
        )
