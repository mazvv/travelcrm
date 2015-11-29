# -*-coding:utf-8-*-

import logging
from datetime import datetime

import pytz
from pyramid_mailer import mailer_factory_from_settings
from pyramid_mailer.message import Message
from pyramid.renderers import render

from ...models.user import User
from ...lib.scheduler import scheduler
from ...lib.utils.common_utils import gen_id
from ...lib.utils.common_utils import translate as _
from ...lib.utils.companies_utils import get_company_url
from ...lib.utils.scheduler_utils import scopped_task, gen_task_id


log = logging.getLogger(__name__)


@scopped_task
def _user_notification(email, subject, html, mailer_settings):
    mailer = mailer_factory_from_settings(mailer_settings)
    message = Message(
        subject=subject,
        sender=mailer.default_sender,
        recipients=(email,),
        html=html
    )
    mailer.send_immediately(message)
    

def _render_mail(request, user, tmpl):
    user.password = gen_id()
    
    return render(
        'travelcrm:templates/users/%s' % tmpl,
        {
            'user': user, 
            'company_url': get_company_url(request)
        },
        request=request,
    )
    

def schedule_user_password_recovery(request, user_id):
    """user's password recovery 
    """
    user = User.get(user_id)
    scheduler.add_job(
        _user_notification,
        trigger='date',
        id=gen_task_id(),
        run_date=datetime.now(pytz.utc),
        args=[
            user.email, 
            _(u'Password recovery'),
            _render_mail(request, user, 'email_password_recovery.mako'),
            request.registry.settings
        ],
    )


def schedule_user_created(request, user_id):
    """new user created 
    """
    user = User.get(user_id)
    scheduler.add_job(
        _user_notification,
        trigger='date',
        id=gen_task_id(),
        run_date=datetime.now(pytz.utc),
        args=[
            user.email,
            _(u'New User created'),
            _render_mail(request, user, 'email_user_created.mako'),
            request.registry.settings
        ],
    )
