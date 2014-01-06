# -*-coding: utf-8 -*-


from zope.interface import implementer
from sqlalchemy import literal

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
from ..models.company_struct import CompanyStruct as _CompanyStruct


@implementer(IResource)
@implementer(IResourcesContainer)
class CompaniesStructures(ResourcesContainerBase):

    __name__ = 'companies_structures'

    _fields = {
        'struct.name': _CompanyStruct.name,
        'company.name': _Company.name,
    }

    def __init__(self, request):
        self.__parent__ = Root(request)
        self.request = request
        self._companies_structures_rid = None

    def set_struct_rid(self, _companies_structures_rid):
        self._companies_structures_rid = _companies_structures_rid

    def get_query_base(self):
        base_query = self._get_query_base()
        query = (
            base_query
            .join(
                _CompanyStruct,
                Resource.company_struct
            )
            .join(
                _Company,
                _CompanyStruct.company
            )
        )
        structs_subquery = (
            DBSession.query(
                _CompanyStruct._companies_structures_rid,
                literal(u'closed').label('state')
            )
            .group_by(_CompanyStruct._companies_structures_rid)
            .subquery()
        )
        query = query.outerjoin(
            structs_subquery,
            structs_subquery.c._companies_structures_rid == _CompanyStruct.rid
        )
        query = query.filter(
            _CompanyStruct.condition_parent_rid(self._companies_structures_rid)
        )
        self._fields['state'] = structs_subquery.c.state

        fields = [
            field.label(label_name)
            for label_name, field
            in self._fields.iteritems()
        ]
        query = query.add_columns(*fields)
        return query


@implementer(IResource)
class CompanyStructure(ResourceBase):

    __name__ = 'company'

    def __init__(self, request):
        self.__parent__ = CompaniesStructures(request)
        self.request = request
