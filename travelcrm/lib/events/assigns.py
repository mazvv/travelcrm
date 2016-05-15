#-*-coding:utf-8-*-

class _AssignMixinEvent(object):
    def __init__(self, request, from_employee, to_employee):
        self.request = request
        self.from_employee = from_employee
        self.to_employee = to_employee


class AssignRun(_AssignMixinEvent):
    pass
