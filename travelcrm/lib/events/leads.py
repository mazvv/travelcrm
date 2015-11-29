#-*-coding:utf-8-*-

class _LeadMixinEvent(object):
    def __init__(self, request, lead):
        self.request = request
        self.lead = lead


class LeadCreated(_LeadMixinEvent):
    pass

class LeadEdited(_LeadMixinEvent):
    pass


class LeadDeleted(_LeadMixinEvent):
    pass


class LeadStatusChanged(_LeadMixinEvent):
    pass
