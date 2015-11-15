#-*-coding:utf-8-*-

class _CampaignMixinEvent(object):
    def __init__(self, request, campaign):
        self.request = request
        self.campaign = campaign


class CampaignCreated(_CampaignMixinEvent):
    pass

class CampaignEdited(_CampaignMixinEvent):
    pass


class CampaignDeleted(_CampaignMixinEvent):
    pass


class CampaignSettings(_CampaignMixinEvent):
    pass
