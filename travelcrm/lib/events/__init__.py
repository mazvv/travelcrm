#-*-coding: utf-8-*-

class BaseMixinEvent(object):
    def __init__(self, request, obj):
        self.request = request
        self.obj = obj

    def registry(self):
        self.request.registry.notify(self)
