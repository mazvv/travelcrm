#-*-coding:utf-8-*-

from . import BaseMixinEvent


class CampaignCreated(BaseMixinEvent):
    pass

class CampaignEdited(BaseMixinEvent):
    pass


class CampaignDeleted(BaseMixinEvent):
    pass


class CampaignSettings(BaseMixinEvent):
    pass


class CampaignAssigned(BaseMixinEvent):
    pass
