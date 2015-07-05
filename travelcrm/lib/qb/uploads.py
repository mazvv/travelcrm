# -*coding: utf-8-*-

from collections import Iterable

from . import ResourcesQueryBuilder

from ...resources.uploads import UploadsResource
from ...models.resource import Resource
from ...models.upload import Upload



class _NameSerializer(object):
    
    def __init__(self, request):
        self.request = request

    def __call__(self, name, row):
        context = UploadsResource(self.request)
        return self.request.resource_url(
            context, 'download', query={'id': row.id}
        )
    
    
class UploadsQueryBuilder(ResourcesQueryBuilder):

    def __init__(self, context):
        super(UploadsQueryBuilder, self).__init__(context)
        self._fields = {
            'id': Upload.id,
            '_id': Upload.id,
            'name': Upload.name,
            'size': Upload.size,
            'media_type': Upload.media_type,
            'download': Upload.name,
        }
        self._serializers = {
            'download': _NameSerializer(self.context.request)  
        }
        self.build_query()

    def build_query(self):
        self.build_base_query()
        self.query = self.query.join(Upload, Resource.upload)
        super(UploadsQueryBuilder, self).build_query()

    def filter_id(self, id):
        assert isinstance(id, Iterable), u"Must be iterable object"
        if id:
            self.query = self.query.filter(Upload.id.in_(id))
