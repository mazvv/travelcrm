# -*-coding: utf-8 -*-

import colander

from . import(
    ResourceSchema, 
    BaseForm,
    BaseSearchForm,
    BaseAssignForm,
)
from ..resources.mails import MailsResource
from ..models.mail import Mail
from ..models.address import Address
from ..models.note import Note
from ..models.task import Task
from ..lib.qb.mails import MailsQueryBuilder
from ..lib.utils.common_utils import translate as _
from ..lib.utils.security_utils import get_auth_employee


@colander.deferred
def name_validator(node, kw):
    request = kw.get('request')

    def validator(node, value):
        mail = Mail.by_name(value)
        if (
            mail
            and str(mail.id) != request.params.get('id')
        ):
            raise colander.Invalid(
                node,
                _(u'Mail with the same name exists'),
            )
    return colander.All(colander.Length(max=255), validator,)


class _MailSchema(ResourceSchema):
    name = colander.SchemaNode(
        colander.String(),
        validator=name_validator,
    )
    subject = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
    )
    descr = colander.SchemaNode(
        colander.String(),
        validator=colander.Length(max=255),
    )
    html_content = colander.SchemaNode(
        colander.String(),
        missing=None
    )


class MailForm(BaseForm):
    _schema = _MailSchema

    def submit(self, mail=None):
        if not mail:
            mail = Mail(
                resource=MailsResource.create_resource(
                    get_auth_employee(self.request)
                )
            )
        else:
            mail.resource.notes = []
            mail.resource.tasks = []
        mail.name = self._controls.get('name')
        mail.subject = self._controls.get('subject')
        mail.html_content = self._controls.get('html_content')
        mail.descr = self._controls.get('descr')
        for id in self._controls.get('note_id'):
            note = Note.get(id)
            mail.resource.notes.append(note)
        for id in self._controls.get('task_id'):
            task = Task.get(id)
            mail.resource.tasks.append(task)
        return mail


class MailSearchForm(BaseSearchForm):
    _qb = MailsQueryBuilder


class MailAssignForm(BaseAssignForm):
    def submit(self, ids):
        for id in ids:
            mail = Mail.get(id)
            mail.resource.maintainer_id = self._controls.get(
                'maintainer_id'
            )
