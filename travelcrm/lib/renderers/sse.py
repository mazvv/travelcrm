#-*-coding: utf-8-*-

import json


class SSERendererFactory(object):
    
    content_type = 'text/event-stream; charset=utf-8'
    cache_control = 'no-cache'

    def __init__(self, info):
        pass

    def __call__(self, value, system):
        request = system.get('request')
        if request is not None:
            response = request.response
            response.content_type = self.content_type
            response.cache_control = self.cache_control
        return 'data:%s\n\n' % json.dumps(value)
