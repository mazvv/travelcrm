#-*-coding:utf-8-*-

class _TaskMixinEvent(object):
    def __init__(self, request, task):
        self.request = request
        self.task = task


class TaskCreated(_TaskMixinEvent):
    pass

class TaskEdited(_TaskMixinEvent):
    pass


class TaskDeleted(_TaskMixinEvent):
    pass
