#-*-coding: utf-8-*-

import pdfkit


class PDFRendererFactory(object):
    
    content_type = 'application/pdf'
    content_encoding = 'binary'
    accept_ranges = 'bytes'

    def __init__(self, info):
        pass

    def __call__(self, value, system):
        request = system.get('request')
        if request is not None:
            response = request.response
            ct = response.content_type
            if ct == response.default_content_type:
                response.content_type = self.content_type
                response.accept_ranges = self.accept_ranges
                response.content_encoding = self.content_encoding
        body = value.get('body')
        pdf = pdfkit.from_string(body, False)
        response.content_disposition = 'inline; filename="%s"' % ''
        return pdf
