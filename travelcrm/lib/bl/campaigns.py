# -*coding: utf-8-*-

from pyramid_mailer import Mailer

from ...resources.campaigns import CampaignsResource

from ...lib.utils.resources_utils import get_resource_settings_by_resource_cls

def get_mailer_settings():
    return get_resource_settings_by_resource_cls(CampaignsResource)


def get_mailer():
    return Mailer().from_settings(get_mailer_settings(), '')
