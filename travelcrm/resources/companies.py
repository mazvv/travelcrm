# -*-coding: utf-8 -*-


from zope.interface import implementer
from sqlalchemy import func

from ..interfaces import (
    IResource,
    IResourcesContainer,
)
from ..resources import (
    Root,
)

from ..resources import (
    ResourcesContainerBase,
    ResourceBase,
)

from ..models import DBSession
from ..models.resource import Resource
from ..models.company import Company as _Company
from ..models.company_struct import CompanyStruct


@implementer(IResource)
@implementer(IResourcesContainer)
class Companies(ResourcesContainerBase):

    __name__ = 'companies'

    _fields = {
        'company.name': _Company.name
    }
    _struct_type = None

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request

    def get_query_base(self):
        base_query = self._get_query_base()
        subq = (
            DBSession.query(
                CompanyStruct._companies_rid,
                func.count(CompanyStruct.rid).label('structs_quan')
            )
            .group_by(
                CompanyStruct._companies_rid
            )
            .subquery()
        )
        query = (
            base_query.join(
                _Company,
                Resource.company
            )
            .outerjoin(
                subq,
                subq.c._companies_rid == _Company.rid
            )
        )
        self._fields['structs.quan'] = subq.c.structs_quan
        fields = [
            field.label(label_name)
            for label_name, field
            in self._fields.iteritems()
        ]
        query = query.add_columns(*fields)
        return query


@implementer(IResource)
class Company(ResourceBase):

    __name__ = 'company'

    def __init__(self, request):
        self.__parent__ = Companies(request)
        self.request = request
