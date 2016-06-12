#-*-coding: utf-8-*-

from mako.template import Template

from ..utils.resources_utils import get_resource_type_by_resource


class STRRendererFactory(object):

    content_type = 'text/html'

    def __init__(self, info):
        pass

    def __call__(self, value, system):
        request = system.get('request')
        if request is not None:
            response = request.response
            ct = response.content_type
            if ct == response.default_content_type:
                response.content_type = self.content_type

        context = system.pop('context', None)
        assert context, 'No context exists'
        
        rt = get_resource_type_by_resource(context)
        tmpl = rt.settings.get(value.get('tmpl', 'html_template'))
        system['_context'] = context
        system.update(value)
        template = Template(tmpl)
        return template.render_unicode(**system)
