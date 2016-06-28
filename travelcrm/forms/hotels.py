# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.hotels import HotelsResource
from ..models.hotel import Hotel
from ..models.hotelcat import Hotelcat
from ..models.location import Location
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.hotels import HotelsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _HotelSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
    hotelcat_id = colander.SchemaNode(
        SelectInteger(Hotelcat),
    )
    location_id = colander.SchemaNode(
        SelectInteger(Location),
        missing=None,
    )


class HotelForm(BaseForm):
    _schema = _HotelSchema

    def submit(self, hotel=None):
        if not hotel:
            hotel = Hotel(
                resource=HotelsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            hotel.resource.notes = []
            hotel.resource.tasks = []
        hotel.name = self._controls.get('name')
        hotel.hotelcat_id = self._controls.get('hotelcat_id')
        hotel.location_id = self._controls.get('location_id')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            hotel.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            hotel.resource.tasks.append(task)
        return hotel


class HotelSearchForm(BaseSearchForm):
    _qb = HotelsQueryBuilder
    

class HotelAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            hotel = Hotel.get(id)
            hotel.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
