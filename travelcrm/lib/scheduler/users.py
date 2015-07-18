# -*-coding:utf-8-*-

import logging
from datetime import datetime

import pytz
from pyramid_mailer import mailer_factory_from_settings
from pyramid_mailer.message import Message
from pyramid.renderers import render

from ...models.user import User
from ...lib.utils.common_utils import get_scheduler, gen_id
from ...lib.utils.common_utils import translate as _
from ...lib.utils.companies_utils import get_company_url


log = logging.getLogger(__name__)


def _user_notification(email, html, mailer_settings):
    subject = _(u'Password recovery')

    mailer = mailer_factory_from_settings(mailer_settings)
    message = Message(
        subject=subject,
        sender=mailer.default_sender,
        recipients=(email,),
        html=html
    )
    mailer.send_immediately(message)
    

def _render_mail(request, user):
    user.password = gen_id()
    
    return render(
        'travelcrm:templates/users/email_password_recovery.mako',
        {
            'user': user, 
            'company_url': get_company_url(request)
        },
        request=request,
    )
    

def schedule_user_password_recovery(request, user_id):
    """user's password recovery 
    """
    scheduler = get_scheduler(request)
    job_id = gen_id(limit=12)

    user = User.get(user_id)
    scheduler.add_job(
        _user_notification,
        trigger='date',
        id=job_id,
        run_date=datetime.now(pytz.utc),
        args=[
            user.email, _render_mail(request, user), request.registry.settings
        ],
    )
