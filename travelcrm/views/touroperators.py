# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.temporal import Temporal
from ..models.touroperator import Touroperator
from ..models.licence import Licence
from ..models.tlicence import TLicence
from ..models.bperson import BPerson
from ..models.tbperson import TBPerson
from ..models.contact import Contact
from ..models.tcontact import TContact
from ..lib.qb.touroperators import (
    TouroperatorsQueryBuilder,
    TouroperatorsLicencesQueryBuilder,
    TouroperatorsBPersonsQueryBuilder,
)
from ..lib.qb.bpersons import BPersonsContactsQueryBuilder
from ..forms.touroperators import TouroperatorSchema
from ..forms.contacts import TContactSchema


log = logging.getLogger(__name__)


class Touroperators(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.touroperators.Touroperators',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = TouroperatorsQueryBuilder(self.context)
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'title': _(u'Add Touroperator'),
            'tid': temporal.id
        }

    @view_config(
        name='add',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = TouroperatorSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            touroperator = Touroperator(
                name=controls.get('name'),
                resource=self.context.create_resource(controls.get('status'))
            )
            licences = temporal.licences.filter(
                TLicence.deleted == False
            )
            for licence in licences:
                touroperator.licences.append(
                    Licence(
                        licence_num=licence.licence_num,
                        date_from=licence.date_from,
                        date_to=licence.date_to
                    )
                )
            DBSession.add(touroperator)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        touroperator = Touroperator.get(self.request.params.get('id'))
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'item': touroperator,
            'title': _(u'Edit Touroperator'),
            'tid': temporal.id
        }

    @view_config(
        name='edit',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = TouroperatorSchema().bind(request=self.request)
        touroperator = Touroperator.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            touroperator.name = controls.get('name')
            touroperator.resource.status = controls.get('status')
            licences = temporal.licences
            for licence in licences:
                if licence.deleted and licence.main_id:
                    DBSession.delete(licence.main)
                elif licence.main_id:
                    licence.main.licence_num = licence.licence_num
                    licence.main.date_from = licence.date_from
                    licence.main.date_to = licence.date_to
                else:
                    touroperator.licences.append(
                        Licence(
                            licence_num=licence.licence_num,
                            date_from=licence.date_from,
                            date_to=licence.date_to,
                        )
                    )

            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            touroperator = Touroperator.get(id)
            if touroperator:
                DBSession.delete(touroperator)
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='licences',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/licences.mak',
        permission='view'
    )
    def licences(self):
        return {}

    @view_config(
        name='licences',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _licences(self):
        qb = TouroperatorsLicencesQueryBuilder()
        qb.union_temporal(
            self.request.params.get('tid'),
            self.request.params.get('touroperator_id'),
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add_licence',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form_licence.mak',
        permission='add'
    )
    def add_licence(self):
        _ = self.request.translate
        return {'title': _(u'Add Licence')}

    @view_config(
        name='add_licence',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_licence(self):
        _ = self.request.translate
        schema = TLicenceSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            row = TLicence(
                licence_num=controls.get('licence_num'),
                date_from=controls.get('date_from'),
                date_to=controls.get('date_to'),
            )
            temporal.licences.append(row)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit_licence',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form_licence.mak',
        permission='edit'
    )
    def edit_licence(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        if id < 0:
            item = TLicence.get(abs(id))
        else:
            item = Licence.get(id)
        return {
            'item': item,
            'title': _(u'Edit Licence')
        }

    @view_config(
        name='edit_licence',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_licence(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        row = (
            TLicence.get(abs(id)) if id < 0 else Licence.get(id)
        )
        schema = TLicenceSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            if isinstance(row, Licence):
                row = TLicence(
                    main_id=row.id
                )
                DBSession.add(row)
            row.licence_num = controls.get('licence_num'),
            row.date_from = controls.get('date_from'),
            row.date_to = controls.get('date_to'),
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete_licence',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/delete_licence.mak',
        permission='delete'
    )
    def delete_licence(self):
        return {
            'tid': self.request.params.get('tid'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete_licence',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete_licence(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            id = int(id)
            row = (
                TLicence.get(abs(id))
                if id < 0 else Licence.get(id)
            )
            if isinstance(row, Licence):
                row = TLicence(
                    main_id=row.id,
                    licence_num=row.licence_num,
                    date_from=row.date_from,
                    date_to=row.date_to,
                    temporal_id=self.request.params.get('tid'),
                )
                DBSession.add(row)
            row.deleted = True
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='bpersons',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _bpersons(self):
        qb = TouroperatorsBPersonsQueryBuilder()
        qb.union_temporal(
            self.request.params.get('tid'),
            self.request.params.get('touroperator_id'),
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add_bperson',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form_bperson.mak',
        permission='add'
    )
    def add_bperson(self):
        _ = self.request.translate
        tid = self.request.params.get('tid')
        return {
            'title': _(u'Add Business Person'),
            'tid': tid,
        }

    @view_config(
        name='add_bperson',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_bperson(self):
        _ = self.request.translate
        schema = TBPersonSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            row = TBPerson(
                first_name=controls.get('first_name'),
                second_name=controls.get('second_name'),
                last_name=controls.get('last_name'),
                position_name=controls.get('position_name'),
            )
            temporal.bpersons.append(row)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit_bperson',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form_bperson.mak',
        permission='edit'
    )
    def edit_bperson(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        if id < 0:
            item = TBPerson.get(abs(id))
        else:
            item = TBPerson.get(id)
        return {
            'item': item,
            'title': _(u'Edit Business Person'),
            'tid': tid
        }

    @view_config(
        name='edit_bperson',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_bperson(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        row = (
            TBPerson.get(abs(id)) if id < 0 else Licence.get(id)
        )
        schema = TBPersonSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            if isinstance(row, BPerson):
                row = TBPerson(
                    main_id=row.id
                )
                DBSession.add(row)
            row.first_name = controls.get('first_name'),
            row.second_name = controls.get('second_name'),
            row.last_name = controls.get('last_name'),
            row.position_name = controls.get('position_name'),
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete_bperson',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/delete_bperson.mak',
        permission='delete'
    )
    def delete_bperson(self):
        return {
            'tid': self.request.params.get('tid'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete_bperson',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete_bperson(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            id = int(id)
            row = (
                TBPerson.get(abs(id))
                if id < 0 else BPerson.get(id)
            )
            if isinstance(row, BPerson):
                row = TBPerson(
                    main_id=row.id,
                    first_name=row.first_name,
                    second_name=row.second_name,
                    last_name=row.last_name,
                    position_name=row.position_name,
                    temporal_id=self.request.params.get('tid'),
                )
                DBSession.add(row)
            row.deleted = True
        return {'success_message': _(u'Deleted')}

    @view_config(
        name='contacts',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/contacts.mak',
        permission='view'
    )
    def contacts(self):
        return {}

    @view_config(
        name='contacts',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _contacts(self):
        qb = BPersonsContactsQueryBuilder()
        qb.union_temporal(
            self.request.params.get('tid'),
            self.request.params.get('bperson_id'),
        )
        qb.sort_query(
            self.request.params.get('sort'),
            self.request.params.get('order', 'asc')
        )
        qb.page_query(
            int(self.request.params.get('rows')),
            int(self.request.params.get('page'))
        )
        return {
            'total': qb.get_count(),
            'rows': qb.get_serialized()
        }

    @view_config(
        name='add_contact',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form_contact.mak',
        permission='add'
    )
    def add_contact(self):
        _ = self.request.translate
        return {'title': _(u'Add Contact')}

    @view_config(
        name='add_contact',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add_contact(self):
        _ = self.request.translate
        schema = TContactSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            row = TContact(
                contact_type=controls.get('contact_type'),
                contact=controls.get('contact'),
            )
            temporal.contacts.append(row)
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit_contact',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/form_contact.mak',
        permission='edit'
    )
    def edit_contact(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        if id < 0:
            item = TContact.get(abs(id))
        else:
            item = Contact.get(id)
        return {
            'item': item,
            'title': _(u'Edit Contact')
        }

    @view_config(
        name='edit_contact',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit_contact(self):
        _ = self.request.translate
        id = int(self.request.params.get('id'))
        row = (
            TContact.get(abs(id)) if id < 0 else Contact.get(id)
        )
        schema = TContactSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            if isinstance(row, Contact):
                row = TContact(
                    main_id=row.id
                )
                DBSession.add(row)
            row.contact_type = controls.get('contact_type')
            row.contact = controls.get('contact')
            row.temporal_id = controls.get('tid')
            return {'success_message': _(u'Saved')}
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete_contact',
        context='..resources.touroperators.Touroperators',
        request_method='GET',
        renderer='travelcrm:templates/touroperators/delete_contact.mak',
        permission='delete'
    )
    def delete_contact(self):
        return {
            'tid': self.request.params.get('tid'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete_contact',
        context='..resources.touroperators.Touroperators',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete_contact(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            id = int(id)
            row = (
                TContact.get(abs(id))
                if id < 0 else Contact.get(id)
            )
            if isinstance(row, Contact):
                row = TContact(
                    main_id=row.id,
                    contact_type=row.contact_type,
                    contact=row.contact,
                    temporal_id=self.request.params.get('tid'),
                )
                DBSession.add(row)
            row.deleted = True
        return {'success_message': _(u'Deleted')}
