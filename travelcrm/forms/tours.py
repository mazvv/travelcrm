# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    SelectInteger,
)
from ..forms.orders_items import (
    OrderItemSchema, 
    OrderItemForm
)
from ..resources.tours import ToursResource
from ..models.tour import Tour
from ..models.person import Person
from ..models.location import Location
from ..models.transport import Transport
from ..models.hotel import Hotel
from ..models.roomcat import Roomcat
from ..models.foodcat import Foodcat
from ..models.accomodation import Accomodation
from ..models.transfer import Transfer
from ..lib.utils.common_utils import cast_int
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def adults_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if (value + int(cast_int(request.params.get('children')))) == 0:
            raise colander.Invalid(
                node,
                _(u'Adult or Children must be more than 0'),
            )
    return validator


class _TourSchema(OrderItemSchema):
    adults = colander.SchemaNode(
        colander.Integer(),
        validator=adults_validator,
    )
    children = colander.SchemaNode(
        colander.Integer(),
    )
    start_location_id = colander.SchemaNode(
        SelectInteger(Location),
    )
    end_location_id = colander.SchemaNode(
        SelectInteger(Location),
    )
    start_transport_id = colander.SchemaNode(
        SelectInteger(Transport),
    )
    end_transport_id = colander.SchemaNode(
        SelectInteger(Transport),
    )
    start_additional_info = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=128),
    )
    end_additional_info = colander.SchemaNode(
        colander.String(),
        missing=None,
        validator=colander.Length(max=128),
    )
    start_date = colander.SchemaNode(
        Date()
    )
    end_date = colander.SchemaNode(
        Date()
    )
    hotel_id = colander.SchemaNode(
        SelectInteger(Hotel),
    )
    accomodation_id = colander.SchemaNode(
        SelectInteger(Accomodation),
        missing=None
    )
    foodcat_id = colander.SchemaNode(
        SelectInteger(Foodcat),
        missing=None
    )
    roomcat_id = colander.SchemaNode(
        SelectInteger(Roomcat),
        missing=None
    )
    transfer_id = colander.SchemaNode(
        SelectInteger(Transfer),
        missing=None
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class TourForm(OrderItemForm):
    _schema = _TourSchema

    def submit(self, tour=None):
        order_item = super(TourForm, self).submit(tour and tour.order_item)
        if not tour:
            tour = Tour(
                resource=ToursResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        tour.order_item = order_item
        tour.adults = self._controls.get('adults')
        tour.children = self._controls.get('children')
        tour.start_location_id = self._controls.get('start_location_id')
        tour.end_location_id = self._controls.get('end_location_id')
        tour.start_date = self._controls.get('start_date')
        tour.end_date = self._controls.get('end_date')
        tour.start_transport_id = self._controls.get('start_transport_id')
        tour.end_transport_id = self._controls.get('end_transport_id')
        tour.start_additional_info = self._controls.get('start_additional_info')
        tour.end_additional_info = self._controls.get('end_additional_info')

        tour.location_id = self._controls.get('location_id')
        tour.hotel_id = self._controls.get('hotel_id')
        tour.accomodation_id = self._controls.get('accomodation_id')
        tour.foodcat_id = self._controls.get('foodcat_id')
        tour.roomcat_id = self._controls.get('roomcat_id')

        tour.descr = self._controls.get('descr')

        for id in self._controls.get('person_id'):
            person = Person.get(id)
            tour.order_item.persons.append(person)
        return tour
