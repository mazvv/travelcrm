#-*-coding:utf-8-*-

from . import BaseMixinEvent


class CampaignCreated(BaseMixinEvent):
    pass


class CampaignChanged(BaseMixinEvent):
    pass


class CampaignDeleted(BaseMixinEvent):
    pass
