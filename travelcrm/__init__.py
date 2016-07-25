# -*-coding: utf-8 -*-

from pyramid.config import Configurator
from sqlalchemy import engine_from_config

from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from pyramid_beaker import session_factory_from_settings

from .models import (
    Base, DBSession
)

from .resources import Root
from .lib.renderers.sse import SSERendererFactory
from .lib.renderers.str import STRRendererFactory


def root_factory(request):
    return Root(request)


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
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
        'colander:locale/',
        'travelcrm:locale/',
    )
    config.add_subscriber(
        '.lib.subscribers.company_schema',
        'pyramid.events.NewRequest'
    )
    config.add_subscriber(
        '.lib.subscribers.company_settings',
        'pyramid.events.NewRequest'
    )
    config.add_subscriber(
        '.lib.subscribers.helpers',
        'pyramid.events.BeforeRender'
    )
    config.add_subscriber(
        '.lib.subscribers.scheduler',
        'pyramid.events.ApplicationCreated'
    )

    config.add_renderer('sse', SSERendererFactory)
    config.add_renderer('str', STRRendererFactory)
    config.add_static_view('css', 'static/css', cache_max_age=3600)
    config.add_static_view('js', 'static/js', cache_max_age=3600)
    config.add_thumb_view('thumbs')

    config.scan()
    return config.make_wsgi_app()
