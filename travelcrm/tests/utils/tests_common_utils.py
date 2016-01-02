#-*-coding: utf-8-*-

from datetime import date

from mock import patch

from ...tests import BaseTestCase
from ...lib.utils.common_utils import parse_date


class TestCommonUtils(BaseTestCase):
    
    @patch('travelcrm.lib.utils.common_utils.get_locale_name')
    def test_parse_date_ru(self, _get_locale_name):
        _get_locale_name.return_value = 'ru'
        s = [
            ('01.02.16', date(2016, 2, 1)),
            ('10.02.16', date(2016, 2, 10)),
            ('01.10.16', date(2016, 10, 1)),
            ('10.11.16', date(2016, 11, 10)),
        ]
        for _s, d in s:
            self.assertEqual(d, parse_date(_s))

    @patch('travelcrm.lib.utils.common_utils.get_locale_name')
    def test_parse_date_en(self, _get_locale_name):
        _get_locale_name.return_value = 'en'
        s = [
            ('1/2/16', date(2016, 1, 2)),
            ('10/2/16', date(2016, 10, 2)),
            ('1/10/16', date(2016, 1, 10)),
            ('10/11/16', date(2016, 10, 11)),
        ]
        for _s, d in s:
            self.assertEqual(d, parse_date(_s))
