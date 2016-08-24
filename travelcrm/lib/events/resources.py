#-*-coding:utf-8-*-

class _ResourceMixinEvent(object):
    def __init__(self, request, obj):
        self.request = request


class ResourceChange(_ResourceMixinEvent):
    pass
