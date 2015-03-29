# -*-coding: utf-8-*-

import logging
import colander

from pyramid.view import view_config, view_defaults
from pyramid.httpexceptions import HTTPFound

from ..models import DBSession
from ..models.wish import Wish
from ..lib.qb.wish import WishQueryBuilder
from ..lib.utils.common_utils import translate as _

from ..forms.wish import WishSchema


log = logging.getLogger(__name__)


@view_defaults(
    context='..resources.wish.WishResource'
)
class WishView(object):

    def __init__(self, context, request):
        self.context = context
        self.request = request

    @view_config(
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/index.mak',
        permission='view'
    )
    def index(self):
        return {}

    @view_config(
        name='list',
        xhr='True',
        request_method='POST',
        renderer='json',
        permission='view'
    )
    def _list(self):
        qb = WishQueryBuilder(self.context)
        qb.search_simple(
            self.request.params.get('q')
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
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/form.mak',
        permission='view'
    )
    def view(self):
        if self.request.params.get('rid'):
            resource_id = self.request.params.get('rid')
            wish_item = Wish.by_resource_id(resource_id)
            return HTTPFound(
                location=self.request.resource_url(
                    self.context, 'view', query={'id': wish_item.id}
                )
            )
        result = self.edit()
        result.update({
            'title': _(u"View Wish Item"),
            'readonly': True,
        })
        return result

    @view_config(
        name='add',
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/form.mak',
        permission='add'
    )
    def add(self):
        return {
            'title': _(u'Add Service'),
        }

    @view_config(
        name='add',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _add(self):
        schema = WishItemSchema().bind(request=self.request)
        try:
            controls = schema.deserialize(self.request.params)
            wish_item = WishItem(
                service_id=controls.get('service_id'),
                currency_id=controls.get('currency_id'),
                price_from=controls.get('price_from'),
                price_to=controls.get('price_to'),
                descr=controls.get('descr'),
                resource=self.context.create_resource()
            )
            DBSession.add(wish_item)
            DBSession.flush()
            return {
                'success_message': _(u'Saved'),
                'response': wish_item.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='edit',
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/form.mak',
        permission='edit'
    )
    def edit(self):
        wish_item = WishItem.get(self.request.params.get('id'))
        return {
            'item': wish_item,
            'title': _(u'Edit Service'),
        }

    @view_config(
        name='edit',
        request_method='POST',
        renderer='json',
        permission='edit'
    )
    def _edit(self):
        schema = WishItemSchema().bind(request=self.request)
        wish_item = WishItem.get(
            self.request.params.get('id')
        )
        try:
            controls = schema.deserialize(self.request.params)
            wish_item.service_id = controls.get('service_id')
            wish_item.currency_id = controls.get('currency_id')
            wish_item.price_from = controls.get('price_from')
            wish_item.price_to = controls.get('price_to')
            wish_item.descr = controls.get('descr')
            return {
                'success_message': _(u'Saved'),
                'response': wish_item.id
            }
        except colander.Invalid, e:
            return {
                'error_message': _(u'Please, check errors'),
                'errors': e.asdict()
            }

    @view_config(
        name='copy',
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/form.mak',
        permission='add'
    )
    def copy(self):
        wish_item = WishItem.get(self.request.params.get('id'))
        return {
            'item': wish_item,
            'title': _(u"Copy Service")
        }

    @view_config(
        name='copy',
        request_method='POST',
        renderer='json',
        permission='add'
    )
    def _copy(self):
        return self._add()

    @view_config(
        name='details',
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/details.mak',
        permission='view'
    )
    def details(self):
        wish_item = WishItem.get(self.request.params.get('id'))
        return {
            'item': wish_item,
        }

    @view_config(
        name='delete',
        request_method='GET',
        renderer='travelcrm:templates/wishes_items/delete.mak',
        permission='delete'
    )
    def delete(self):
        return {
            'title': _(u'Delete Services Items'),
            'id': self.request.params.get('id')
        }

    @view_config(
        name='delete',
        request_method='POST',
        renderer='json',
        permission='delete'
    )
    def _delete(self):
        errors = 0
        for id in self.request.params.getall('id'):
            item = WishItem.get(id)
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
