# -*-coding: utf-8 -*-

import colander

from . import(
    Date,
    SelectInteger,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.vats import VatsResource
from ..models import DBSession
from ..models.vat import Vat
from ..models.service import Service
from ..models.account import Account
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.vats import VatsQueryBuilder
from ..lib.utils.security_utils import get_auth_employee
from ..lib.utils.common_utils import translate as _


@colander.deferred
def date_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        vat = (
            DBSession.query(Vat)
            .filter(
                Vat.date == value,
                Vat.account_id == request.params.get('account_id'),
                Vat.service_id == request.params.get('service_id'), 
            )
            .first()
        )
        if (
            vat
            and str(vat.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Vat for this date exists'),
            )
    return colander.All(validator,)


class _VatSchema(ResourceSchema):
    date = colander.SchemaNode(
        Date(),
        validator=date_validator,
    )
    account_id = colander.SchemaNode(
        SelectInteger(Account),
    )
    service_id = colander.SchemaNode(
        SelectInteger(Service),
    )
    vat = colander.SchemaNode(
        colander.Decimal('.01'),
        validator=colander.Range(min=0, max=100),
    )
    calc_method = colander.SchemaNode(
        colander.String()
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class VatForm(BaseForm):
    _schema = _VatSchema

    def submit(self, vat=None):
        if not vat:
            vat = Vat(
                resource=VatsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            vat.resource.notes = []
            vat.resource.tasks = []
        vat.date = self._controls.get('date')
        vat.account_id = self._controls.get('account_id')
        vat.service_id = self._controls.get('service_id')
        vat.vat = self._controls.get('vat')
        vat.calc_method = self._controls.get('calc_method')
        vat.descr = self._controls.get('descr')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            vat.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            vat.resource.tasks.append(task)
        return vat


class VatSearchForm(BaseSearchForm):
    _qb = VatsQueryBuilder


class VatAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            vat = Vat.get(id)
            vat.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
