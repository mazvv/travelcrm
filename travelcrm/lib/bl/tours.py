# -*coding: utf-8-*-

from ...models import DBSession
from ...models.resource import Resource
from ...models.tour import Tour
from ...models.person import Person


class TourInvoice(object):

    @classmethod
    def query_list(cls):
        query = (
            DBSession.query(
                Resource.id.label('resource_id'),
                Person.name.label('customer'),
                Tour.price.label('sum'),
            )
            .join(Resource, Tour.resource)
            .join(Person, Tour.customer)
        )
        return query
