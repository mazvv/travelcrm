# -*-coding: utf-8 -*-

import colander

from . import (
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.touroperator import TouroperatorResource
from ..models.touroperator import Touroperator
from ..models.licence import Licence
from ..models.bperson import BPerson
from ..models.commission import Commission
from ..models.bank_detail import BankDetail
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.touroperator import TouroperatorQueryBuilder
from ..lib.utils.common_utils import translate as _


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        touroperator = Touroperator.by_name(value)
        if (
            touroperator
            and str(touroperator.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Touroperator with the same name exists'),
            )
    return colander.All(colander.Length(max=32), validator,)


class _TouroperatorSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator
    )
    licence_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    bperson_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    bank_detail_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )
    commission_id = colander.SchemaNode(
        colander.Set(),
        missing=[],
    )

    def deserialize(self, cstruct):
        if (
            'licence_id' in cstruct
            and not isinstance(cstruct.get('licence_id'), list)
        ):
            val = cstruct['licence_id']
            cstruct['licence_id'] = list()
            cstruct['licence_id'].append(val)

        if (
            'bperson_id' in cstruct
            and not isinstance(cstruct.get('bperson_id'), list)
        ):
            val = cstruct['bperson_id']
            cstruct['bperson_id'] = list()
            cstruct['bperson_id'].append(val)

        if (
            'bank_detail_id' in cstruct
            and not isinstance(cstruct.get('bank_detail_id'), list)
        ):
            val = cstruct['bank_detail_id']
            cstruct['bank_detail_id'] = list()
            cstruct['bank_detail_id'].append(val)

        if (
            'commission_id' in cstruct
            and not isinstance(cstruct.get('commission_id'), list)
        ):
            val = cstruct['commission_id']
            cstruct['commission_id'] = list()
            cstruct['commission_id'].append(val)

        return super(_TouroperatorSchema, self).deserialize(cstruct)


class TouroperatorForm(BaseForm):
    _schema = _TouroperatorSchema

    def submit(self, touroperator=None):
        context = TouroperatorResource(self.request)
        if not touroperator:
            touroperator = Touroperator(
                resource=context.create_resource()
            )
        else:
            touroperator.licences = []
            touroperator.commissions = []
            touroperator.bpersons = []
            touroperator.banks_details = []
            touroperator.resource.notes = []
            touroperator.resource.tasks = []
        touroperator.name = self._controls.get('name')
        for id in self._controls.get('licence_id'):
            licence = Licence.get(id)
            touroperator.licences.append(licence)
        for id in self._controls.get('bperson_id'):
            bperson = BPerson.get(id)
            touroperator.bpersons.append(bperson)
        for id in self._controls.get('bank_detail_id'):
            bank_detail = BankDetail.get(id)
            touroperator.banks_details.append(bank_detail)
        for id in self._controls.get('commission_id'):
            commission = Commission.get(id)
            touroperator.commissions.append(bank_detail)
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            touroperator.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            touroperator.resource.tasks.append(task)
        return touroperator


class TouroperatorSearchForm(BaseSearchForm):
    _qb = TouroperatorQueryBuilder
