# -*-coding: utf-8 -*-

import colander

from . import(
    PhoneNumber,
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
)
from ..resources.contacts import ContactsResource
from ..models.contact import Contact
from ..lib.qb.contacts import ContactsQueryBuilder


@colander.deferred
def contact_validator(node, kw):
    request = kw.get('request')

    validators = [colander.Length(min=2, max=64), ]
    if request.params.get('contact_type') == 'phone':
        validators.append(PhoneNumber())
    elif request.params.get('contact_type') == 'email':
        validators.append(colander.Email())

    return colander.All(*validators)


class _ContactSchema(ResourceSchema):
    contact_type = colander.SchemaNode(
        colander.String(),
    )
    contact = colander.SchemaNode(
        colander.String(),
        validator=contact_validator
    )
    status = colander.SchemaNode(
        colander.String(),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
        missing=u''
    )


class ContactForm(BaseForm):
    _schema = _ContactSchema

    def submit(self, contact=None):
        context = ContactsResource(self.request)
        if not contact:
            contact = Contact(
                resource=context.create_resource()
            )
        contact.contact_type = self._controls.get('contact_type')
        contact.contact = self._controls.get('contact')
        contact.descr = self._controls.get('descr')
        contact.status = self._controls.get('status')
        return contact


class ContactSearchForm(BaseSearchForm):
    _qb = ContactsQueryBuilder
