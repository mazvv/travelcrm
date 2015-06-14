# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm
)
from ..resources.hotels import HotelsResource
from ..models.hotel import Hotel
from ..models.task import Task
from ..models.note import Note
from ..lib.qb.hotels import HotelsQueryBuilder


class _HotelSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=32),
    )
    hotelcat_id = colander.SchemaNode(
        colander.Integer(),
    )
    location_id = colander.SchemaNode(
        colander.Integer(),
        missing=None
    )


class HotelForm(BaseForm):
    _schema = _HotelSchema

    def submit(self, hotel=None):
        context = HotelsResource(self.request)
        if not hotel:
            hotel = Hotel(
                resource=context.create_resource()
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
