# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config

from ..models import DBSession
from ..models.posting import Posting
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.postings import PostingsQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.postings import PostingSchema


log = logging.getLogger(__name__)


class Postings(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        context='..resources.postings.Postings',
        request_method='GET',
        renderer='travelcrm:templates/postings/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        context='..resources.postings.Postings',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def list(self):
        qb = PostingsQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q'),
        )
        qb.advanced_search(
            **self.request.params.mixed()
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
        name='view',
        context='..resources.postings.Postings',
        request_method='GET',
        renderer='travelcrm:templates/postings/form.mak',
        permission='view'
    )
    def view(self):
        result = self.edit()
        result.update({
            'title': _(u"View Posting"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        context='..resources.postings.Postings',
        request_method='GET',
        renderer='travelcrm:templates/postings/form.mak',
        permission='add'
    )
    def add(self):
        return {'title': _(u'Add Posting')}

    @view_config(
        name='add',
        context='..resources.postings.Postings',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = PostingSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params.mixed())
            posting = Posting(
                date=controls.get('date'),
                account_from_id=controls.get('account_from_id'),
                account_to_id=controls.get('account_to_id'),
                account_item_id=controls.get('account_item_id'),
                sum=controls.get('sum'),
                resource=self.context.create_resource()
            )
            for id in controls.get('note_id'):
                note = Note.get(id)
                posting.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                posting.resource.tasks.append(task)
            DBSession.add(posting)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': posting.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        context='..resources.postings.Postings',
        request_method='GET',
        renderer='travelcrm:templates/postings/form.mak',
        permission='edit'
    )
    def edit(self):
        posting = Posting.get(self.request.params.get('id'))
        return {'item': posting, 'title': _(u'Edit Posting')}

    @view_config(
        name='edit',
        context='..resources.postings.Postings',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = PostingSchema().bind(request=self.request)
        posting = Posting.get(self.request.params.get('id'))
        try:
            controls = schema.deserialize(self.request.params.mixed())
            posting.date = controls.get('date')
            posting.account_from_id = controls.get('account_from_id')
            posting.account_to_id = controls.get('account_to_id')
            posting.account_item_id = controls.get('account_item_id')
            posting.sum = controls.get('sum')
            posting.resource.notes = []
            posting.resource.tasks = []
            for id in controls.get('note_id'):
                note = Note.get(id)
                posting.resource.notes.append(note)
            for id in controls.get('task_id'):
                task = Task.get(id)
                posting.resource.tasks.append(task)
            return {
                'success_message': _(u'Saved'),
                'response': posting.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='delete',
        context='..resources.postings.Postings',
        request_method='GET',
        renderer='travelcrm:templates/postings/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Postings'),
            'rid': self.request.params.get('rid')
        }

    @view_config(
        name='delete',
        context='..resources.postings.Postings',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = Posting.get(id)
            if item:
                DBSession.begin_nested()
                try:
                    DBSession.delete(item)
                    DBSession.commit()
                except:
                    errors += 1
                    DBSession.rollback()
        if errors > 0:
            return {
                'error_message': _(
                    u'Some objects could not be delete'
                ),
            }
        return {'success_message': _(u'Deleted')}
