# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.temporal import Temporal
from ..models.licence import Licence
from ..lib.qb.licences import LicencesQueryBuilder
from ..lib.utils.common_utils import gen_id

from ..forms.licences import LicenceSchema


log = logging.getLogger(__name__)


class Licences(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.licences.Licences',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = LicencesQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
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
        name="field",
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/field.mak',
        permission='view'
    )
    def field(self):
        if (
            self.request.params.get('ref_name')
            and self.request.params.get('ref_id')
        ):
            qb = LicencesQueryBuilder(self.context)
            qb.filter_reference(
                self.request.params.get('ref_name'),
                self.request.params.get('ref_id')
            )
        return self.index()

    @view_config(
        name='field',
        context='..resources.licences.Licences',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _field(self):
        qb = LicencesQueryBuilder(self.context)
        qb.filter_id(self.request.params.get('id'))
        qb.search_simple(
            self.request.params.get('q')
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
        name='add',
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/form.mak',
        permission='add'
    )
    def add(self):
        _ = self.request.translate
        return {
            'title': _(u'Add Licence'),
        }

    @view_config(
        name='add',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        _ = self.request.translate
        schema = LicenceSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            licence = Licence(
                licence_num=controls.get('licence_num'),
                date_from=controls.get('date_from'),
                date_to=controls.get('date_to'),
                resource=self.context.create_resource(controls.get('status'))
            )
            DBSession.add(licence)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'id': licence.id,
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/form.mak',
        permission='edit'
    )
    def edit(self):
        _ = self.request.translate
        licence = Licence.get(self.request.params.get('id'))
        temporal = Temporal()
        DBSession.add(temporal)
        return {
            'item': licence,
            'title': _(u'Edit Licence'),
            'tid': temporal.id
        }

    @view_config(
        name='edit',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        _ = self.request.translate
        schema = LicenceSchema().bind(request=self.request)
        licence = Licence.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            temporal = Temporal.get(controls.get('tid'))
            licence.first_name = controls.get('first_name')
            licence.last_name = controls.get('last_name')
            licence.second_name = controls.get('second_name')
            licence.position_name = controls.get('position_name')
            licence.resource.status = controls.get('status')
            contacts = temporal.contacts
            for contact in contacts:
                if contact.deleted and contact.main_id:
                    DBSession.delete(contact.main)
                elif contact.main_id:
                    contact.main.contact_type = contact.contact_type
                    contact.main.contact = contact.contact
                else:
                    licence.contacts.append(
                        Contact(
                            contact_type=contact.contact_type,
                            contact=contact.contact
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
        context='..resources.licences.Licences',
        request_method='GET',
        renderer='travelcrm:templates/licences/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.licences.Licences',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        _ = self.request.translate
        for id in self.request.params.getall('id'):
            licence = Licence.get(id)
            if licence:
                DBSession.delete(licence)
        return {'success_message': _(u'Deleted')}
