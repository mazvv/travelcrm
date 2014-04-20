# -*-coding: utf-8 -*-

from pyramid.config import Configurator
from sqlalchemy import engine_from_config

from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from pyramid_beaker import session_factory_from_settings

from .models import (
    DBSession,
    Base,
)

from .resources import Root


def root_factory(request):
    return Root(request)


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    Base.metadata.bind = engine

    session_factory = session_factory_from_settings(settings)
    authentication = AuthTktAuthenticationPolicy(
        settings.get('session.secret'),
    )
    authorization = ACLAuthorizationPolicy()

    config = Configurator(
        settings=settings,
        root_factory=root_factory,
        authentication_policy=authentication,
        authorization_policy=authorization,
        session_factory=session_factory,
    )

    config.add_translation_dirs(
        'colander:locale',
        'travelcrm:locale',
    )
    config.add_subscriber(
        '.subscribers.helpers',
        'pyramid.events.BeforeRender'
    )

    config.add_static_view('css', 'static/css', cache_max_age=3600)
    config.add_static_view('js', 'static/js', cache_max_age=3600)

    config.scan()
    return config.make_wsgi_app()
