# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
)
from ..forms.orders_items import (
    OrderItemSchema, 
    OrderItemForm
)
from ..resources.spassports import SpassportsResource
from ..models.spassport import Spassport
from ..models.person import Person
from ..lib.utils.common_utils import cast_int
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def adults_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        if (value + int(cast_int(request.params.get('children')))) == 0:
            raise colander.Invalid(
                node,
                _(u'Adult or Children must be more than 0'),
            )
    return validator


class _SpassportSchema(OrderItemSchema):
    photo_done = colander.SchemaNode(
        colander.Boolean(false_choices=("", "0", "false"), true_choices=("1")),
    )
    docs_receive_date = colander.SchemaNode(
        Date(),
        missing=None,
    )
    docs_transfer_date = colander.SchemaNode(
        Date(),
        missing=None,
    )
    passport_receive_date = colander.SchemaNode(
        Date(),
        missing=None,
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class SpassportForm(OrderItemForm):
    _schema = _SpassportSchema

    def submit(self, spassport=None):
        order_item = super(SpassportForm, self).submit(spassport and spassport.order_item)
        if not spassport:
            spassport = Spassport(
                resource=SpassportsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        spassport.order_item = order_item
        spassport.photo_done = self._controls.get('photo_done')
        spassport.docs_receive_date = self._controls.get('docs_receive_date')
        spassport.docs_transfer_date = self._controls.get('docs_transfer_date')
        spassport.passport_receive_date = \
            self._controls.get('passport_receive_date')

        spassport.descr = self._controls.get('descr')

        for id in self._controls.get('person_id'):
            person = Person.get(id)
            spassport.order_item.persons.append(person)
        return spassport
