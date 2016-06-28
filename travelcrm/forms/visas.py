# -*-coding: utf-8 -*-

import colander

from . import (
    Date,
    SelectInteger,
)
from ..forms.orders_items import (
    OrderItemSchema, 
    OrderItemForm
)
from ..resources.visas import VisasResource
from ..models.visa import Visa
from ..models.country import Country
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


class _VisaSchema(OrderItemSchema):
    country_id = colander.SchemaNode(
        SelectInteger(Country),
    )
    type = colander.SchemaNode(
        colander.String()
    )
    start_date = colander.SchemaNode(
        Date()
    )
    end_date = colander.SchemaNode(
        Date(),
        missing=None,
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=None
    )


class VisaForm(OrderItemForm):
    _schema = _VisaSchema

    def submit(self, visa=None):
        order_item = super(VisaForm, self).submit(visa and visa.order_item)
        if not visa:
            visa = Visa(
                resource=VisasResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        visa.order_item = order_item
        visa.country_id = self._controls.get('country_id')
        visa.type = self._controls.get('type')
        visa.start_date = self._controls.get('start_date')
        visa.end_date = self._controls.get('end_date')

        visa.descr = self._controls.get('descr')

        for id in self._controls.get('person_id'):
            person = Person.get(id)
            visa.order_item.persons.append(person)
        return visa
