# -*-coding: utf-8 -*-

import colander

from . import (
    SelectInteger,
    ResourceSchema, 
    BaseForm, 
    BaseSearchForm
)
from ..resources.addresses import AddressesResource
from ..models.address import Address
from ..models.location import Location
from ..lib.qb.addresses import AddressesQueryBuilder
from ..lib.utils.security_utils import get_auth_employee


class _AddressSchema(ResourceSchema):
    location_id = colander.SchemaNode(
        SelectInteger(Location),
    )
    zip_code = colander.SchemaNode(
        colander.String()
    )
    address = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(min=2, max=255)
    )


class AddressForm(BaseForm):
    _schema = _AddressSchema

    def submit(self, address=None):
        if not address:
            address = Address(
                resource=AddressesResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        address.location_id = self._controls.get('location_id')
        address.zip_code = self._controls.get('zip_code')
        address.address = self._controls.get('address')
        return address


class AddressSearchForm(BaseSearchForm):
    _qb = AddressesQueryBuilder
