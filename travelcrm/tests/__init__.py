#-*-coding: utf-8-*-

import logging
import unittest
import os

from sqlalchemy import engine_from_config
from sqlalchemy.orm import sessionmaker

from pyramid import testing
from pyramid.compat import configparser

from travelcrm.models import DBSession, Base


log = logging.getLogger(__name__)


def get_settings():
    settings = dict()
    config = configparser.ConfigParser()
    config.read('test.ini')
    for option in config.options('app:main'):
        settings[option] = config.get('app:main', option)
    return settings


class BaseTestCase(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.settings = get_settings()
        cls.engine = engine_from_config(cls.settings, prefix='sqlalchemy.')
        cls.DBSession = sessionmaker()

    def setUp(self):
        self.config = testing.setUp(settings=self.settings)
        DBSession.configure(bind=self.engine)
        Base.metadata.bind = self.engine
        
    def tearDown(self):
        testing.tearDown()
