#-*-coding: utf-8-*-

import unittest

from sqlalchemy import engine_from_config
from sqlalchemy.orm import sessionmaker

from pyramid import testing
from pyramid.compat import configparser

from travelcrm.models import DBSession, Base


def get_settings():
    settings = dict()
    config = configparser.ConfigParser()
    config.read('test.ini')
    for option in config.options('app:main'):
        settings[option] = config.get('app:main', option)
    return settings


class BaseTestCase(unittest.TestCase):

    def setUp(self):
        engine = engine_from_config(get_settings(), 'sqlalchemy.')
        DBSession.configure(bind=engine)
        Base.metadata.bind = engine
        Base.query = DBSession.query_property()
        Base.metadata.create_all()

    def tearDown(self):
        testing.tearDown()
        DBSession.remove()
