#-*-coding:utf-8-*-

class _UserMixinEvent(object):
    def __init__(self, request, user):
        self.request = request
        self.user = user


class UserCreated(_UserMixinEvent):
    pass

class UserEdited(_UserMixinEvent):
    pass


class UserDeleted(_UserMixinEvent):
    pass


class UserLoggedIn(_UserMixinEvent):
    pass


class UserPasswdRecovery(_UserMixinEvent):
    pass
