# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.structure import Structure
from ..models.contact import Contact
from ..models.address import Address
from ..models.bank_detail import BankDetail
from ..lib.qb.structures import StructuresQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..forms.structures import StructureSchema


log = logging.getLogger(__name__)


class Structures(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.structures.Structures',
        request_method='GET',
        renderer='travelcrm:templates/structures/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.structures.Structures',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        parent_id = self.request.params.get('id')

        qb = StructuresQueryBuilder(self.context)
        qb.filter_parent_id(
            parent_id,
            with_chain=self.request.params.get('with_chain')
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        if self.request.params.get('rows'):
            qb.page_query(
                int(self.request.params.get('rows')),
                int(self.request.params.get('page', 1))
            )
        return qb.get_serialized()

    @view_config(
        name='add',
        context='..resources.structures.Structures',
        request_method='GET',
        renderer='travelcrm:templates/structures/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u"Add Company Structure")
        }

    @view_config(
        name='add',
        context='..resources.structures.Structures',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = StructureSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params.mixed())
            structure = Structure(
                name=controls.get('name'),
                parent_id=controls.get('parent_id'),
                resource=self.context.create_resource()
            )
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                structure.contacts.append(contact)
            for id in controls.get('address_id'):
                address = Address.get(id)
                structure.addresses.append(address)
            for id in controls.get('bank_detail_id'):
                bank_detail = BankDetail.get(id)
                structure.banks_details.append(bank_detail)
            DBSession.add(structure)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.structures.Structures',
        request_method='GET',
        renderer='travelcrm:templates/structures/form.mak',
        permission='edit'
    )
    def edit(self):
        structure = Structure.get(self.request.params.get('id'))
        return {
            'title': _(u"Edit Company Structure"),
            'item': structure,
        }

    @view_config(
        name='edit',
        context='..resources.structures.Structures',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = StructureSchema().bind(request=self.request)
        structure = Structure.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            structure.name = controls.get('name')
            structure.parent_id = controls.get('parent_id')
            structure.contacts = []
            structure.addresses = []
            structure.banks_details = []
            for id in controls.get('contact_id'):
                contact = Contact.get(id)
                structure.contacts.append(contact)
            for id in controls.get('address_id'):
                address = Address.get(id)
                structure.addresses.append(address)
            for id in controls.get('bank_detail_id'):
                bank_detail = BankDetail.get(id)
                structure.banks_details.append(bank_detail)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.structures.Structures',
        request_method='GET',
        renderer='travelcrm:templates/structures/form.mak',
        permission='add'
    )
    def copy(self):
        structure = Structure.get(self.request.params.get('id'))
        return {
            'title': _(u"Copy Company Structure"),
            'item': structure,
        }

    @view_config(
        name='copy',
        context='..resources.structures.Structures',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.structures.Structures',
        request_method='GET',
        renderer='travelcrm:templates/structures/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.structures.Structures',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            structure = Structure.get(id)
            if structure:
                DBSession.delete(structure)
        return {'success_message': _(u'Deleted')}
