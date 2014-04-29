# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.bperson import BPerson
from ..models.contact import Contact
from ..lib.qb.bpersons import BPersonsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.bpersons import BPersonSchema


log = logging.getLogger(__name__)


class BPersons(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.bpersons.BPersons',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = BPersonsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            updated_from=self.request.params.get('updated_from'),
            updated_to=self.request.params.get('updated_to'),
            modifier_id=self.request.params.get('modifier_id'),
        )
        id = self.request.params.get('id')
        if id:
            qb.filter_id(id.split(','))
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
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Business Person'),
        }

    @view_config(
        name='add',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = BPersonSchema().bind(request=self.request)

        try:
            controls = schema.deserialize(self.request.params)
            bperson = BPerson(
                first_name=controls.get('first_name'),
                last_name=controls.get('last_name'),
                second_name=controls.get('second_name'),
                position_name=controls.get('position_name'),
                resource=self.context.create_resource()
            )
            if self.request.params.getall('contact_id'):
                bperson.contacts = (
                    DBSession.query(Contact)
                    .filter(
                        Contact.id.in_(
                            self.request.params.getall('contact_id')
                        )
                    )
                    .all()
                )
            DBSession.add(bperson)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': bperson.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='edit'
    )
    def edit(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
            'title': _(u'Edit Business Person'),
        }

    @view_config(
        name='edit',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = BPersonSchema().bind(request=self.request)
        bperson = BPerson.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params)
            bperson.first_name = controls.get('first_name')
            bperson.last_name = controls.get('last_name')
            bperson.second_name = controls.get('second_name')
            bperson.position_name = controls.get('position_name')
            if self.request.params.getall('contact_id'):
                bperson.contacts = (
                    DBSession.query(Contact)
                    .filter(
                        Contact.id.in_(
                            self.request.params.getall('contact_id')
                        )
                    )
                    .all()
                )
            else:
                bperson.contacts = []
            return {
                'success_message': _(u'Saved'),
                'response': bperson.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/form.mak',
        permission='add'
    )
    def copy(self):
        bperson = BPerson.get(self.request.params.get('id'))
        return {
            'item': bperson,
            'title': _(u"Copy Business Person")
        }

    @view_config(
        name='copy',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='delete',
        context='..resources.bpersons.BPersons',
        request_method='GET',
        renderer='travelcrm:templates/bpersons/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        context='..resources.bpersons.BPersons',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        for id in self.request.params.getall('id'):
            bperson = BPerson.get(id)
            if bperson:
                DBSession.delete(bperson)
        return {'success_message': _(u'Deleted')}
