# -*coding: utf-8-*-

from smpplib.client import Client
from pyramid_mailer import Mailer

from ...resources.campaigns import CampaignsResource

from ...lib.utils.resources_utils import get_resource_settings_by_resource_cls

def get_mailer_settings():
    settings = get_resource_settings_by_resource_cls(CampaignsResource)
    result = {}
    for key in settings:
        if key.endswith('_smtp'):
            result[key.rsplit('_', 1)[0]] = settings[key]
    return result


def get_mailer():
    return Mailer().from_settings(get_mailer_settings(), '')


def get_smpp_settings():
    settings = get_resource_settings_by_resource_cls(CampaignsResource)
    result = {}
    for key in settings:
        if key.endswith('_smpp'):
            result[key.rsplit('_', 1)[0]] = settings[key]
    return result


def get_smpp_client():
    settings = get_smpp_settings()
    client = Client(settings['host'], settings['port'])
    kwargs = {
        'system_id': settings['username'],
        'password': settings['password']
    }
    client.connect()
    if settings['system_type'] == 'transceiver':
        client.bind_transceiver(**kwargs)
    elif settings['system_type'] == 'receiver':
        client.bind_receiver(**kwargs)
    else:
        client.bind_transmitter(**kwargs)
    return client
