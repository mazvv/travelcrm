# -*coding: utf-8-*-

import json
from collections import namedtuple

from pytz import common_timezones
from webhelpers.html import tags
from webhelpers.html import HTML

from ...interfaces import IServiceType
from ...resources.accomodation import AccomodationResource
from ...resources.employee import EmployeeResource
from ...resources.position import PositionResource
from ...resources.bperson import BPersonResource
from ...resources.hotelcat import HotelcatResource
from ...resources.country import CountryResource
from ...resources.region import RegionResource
from ...resources.location import LocationResource
from ...resources.supplier import SupplierResource
from ...resources.roomcat import RoomcatResource
from ...resources.foodcat import FoodcatResource
from ...resources.hotel import HotelResource
from ...resources.currency import CurrencyResource
from ...resources.person import PersonResource
from ...resources.advsource import AdvsourceResource
from ...resources.bank import BankResource
from ...resources.service import ServiceResource
from ...resources.account import AccountResource
from ...resources.invoice import InvoiceResource
from ...resources.subaccount import SubaccountResource
from ...resources.transfer import TransferResource
from ...resources.transport import TransportResource

from ...models.task import Task
from ...models.account import Account
from ...models.account_item import AccountItem
from ...models.resource_type import ResourceType
from ...models.contact import Contact
from ...models.person import Person
from ...models.passport import Passport
from ...models.notification import EmployeeNotification
from ...models.lead import Lead
from ...models.order_item import OrderItem
from ...models.supplier import Supplier

from ..utils.common_utils import (
    gen_id,
    get_date_format,
    get_datetime_format,
    format_date,
    format_datetime,
)
from ..utils.common_utils import translate as _
from ..utils.resources_utils import get_resources_types_by_interface
from ..bl.subaccounts import get_subaccounts_types


tool = namedtuple('tool', ('name', 'url', 'icon', 'title', 'with_row'))


class _ComboGridField(object):

    def __init__(
        self, request, resource, name, value, url, fields, id_field='id',
        text_field='name', tools=None, id=None, show_toolbar=True, 
        data_options=None, **kwargs
    ):
        self._request = request
        self._resource = resource
        self._name = name
        self._value = value
        self._url = url
        self._fields = fields
        self._id_field = id_field
        self._text_field = text_field
        self._id = id or gen_id()
        self._tools = tools
        self._show_toolbar = show_toolbar
        self._data_options = data_options
        self._html_attrs = kwargs

    def _render_tool(self, tool):
        tmp = "container:'#%(id)s',action:'dialog_open',url:'%(url)s'"
        if tool.with_row:
            tmp += ",property:'with_row'"
        kwargs = {
            'data-options': tmp % {'id': self._id, 'url': tool.url}
        }
        return HTML.tag(
            'a', href='#',
            class_='fa %(icon)s easyui-tooltip _action' % {'icon': tool.icon},
            title=tool.title,
            **kwargs
        )

    def _render_toolbar(self):
        permisions = self._resource.get_permisions(
            self._resource, self._request
        )
        if not permisions:
            return
        toolbar = [
            self._render_tool(tool) 
            for tool in self._tools 
            if tool.name in permisions
        ]
        if toolbar:
            toolbar = HTML.tag(
                'span', class_='combogrid-toolbar', id=gen_id(),
                c=HTML(*toolbar)
            )
        return toolbar

    def _render_on_before_load(self):
        return """
            onBeforeLoad: function(param){
                var this_selector = '#%(obj_id)s';
                var response_id = $(this_selector).data('response');
                var id = %(id)s;
                if(response_id){
                    param.id = response_id;
                    param.q = '';
                }
                else if(id && typeof(param.q) == 'undefined'){
                    param.id = id;
                }
                if(!param.page){
                    param.page = 1;
                    param.rows = 50;
                }
            },
        """ % {
            'id': json.dumps(self._value),
            'obj_id': self._id,
        }

    def _render_on_load_success(self):
        return """
            onLoadSuccess: function(){
                var this_selector = '#%(obj_id)s';
                var response_id = $(this_selector).data('response');
                if(response_id){
                    $(this_selector).combogrid('clear');
                    $(this_selector).combogrid('setValue', response_id);
                    $(this_selector).data('response', '');
                }
            },
        """ % {'obj_id': self._id,}

    def _render_data_options(self):
        return """
            url: '%(url)s',
            fitColumns: true,
            scrollbarSize: 7,
            border: false,
            delay: 500,
            idField: '%(id_field)s',
            textField: '%(text_field)s',
            mode: 'remote',
            sortName: 'id',
            sortOrder: 'desc',
            columns: %(columns)s,
            pageSize: 50,
            showHeader: false,
            view: bufferview,
            %(on_before_load)s
            %(on_success_load)s
        """ % ({
            'url': self._url,
            'id_field': self._id_field,
            'text_field': self._text_field,
            'columns': (
                json.dumps(self._fields) 
                if not isinstance(self._fields, basestring) 
                else self._fields
            ),
            'id': json.dumps(self._value),
            'obj_id': self._id,
            'on_before_load': self._render_on_before_load(),
            'on_success_load': self._render_on_load_success()
        })

    def __call__(self):
        if self._show_toolbar:
            toolbar = self._render_toolbar()
        else:
            toolbar = None
        return HTML(
           tags.text(
               self._name, self._value, id=self._id,
               class_="easyui-combogrid text w20",
               data_options=self._render_data_options(),
               **self._html_attrs
           ),
           toolbar if toolbar else ''
        )


def _combotree_field(
    name, value, url, sort, order='asc', data_options=None, **kwargs
):
    _data_options = """
        url: '%(url)s',
        onBeforeLoad: function(node, param){
            param.sort = '%(sort)s';
            param.order = '%(order)s';
    """ % {'url': url, 'sort': sort, 'order': order}
    if value:
        _data_options += """
            if(!node){
                param.id = %s;
                param.with_chain = true;
            }
        """ % value

    _data_options += """
        }
    """
    if value:
        _data_options += """,
            onLoadSuccess: function(node, data){
                if(!node){
                    var n = $(this).tree('find', %s);
                    $(this).tree('expandTo', n.target);
                    $(this).tree('scrollTo', n.target);
                }
            }
        """ % value
    if data_options:
        _data_options += ',%s' % data_options

    return tags.text(
        name, value, class_="easyui-combotree text w20",
        data_options=_data_options, **kwargs
    )


def employees_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name', 'title': _(u"name"), 'sortable': True, 'width': 200}
    ]]
    tools = (
        tool('add', '/employee/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/employee/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/employee/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, EmployeeResource, name, value, '/employee/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def positions_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = """[[{
        field: 'position_name', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return '<span class="b">' + value + '</span><br/>'
            + row.structure_path.join(' &rarr; ');
        }
    }]]""" % {'title': _(u'name')}
    tools = (
        tool('add', '/position/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/position/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/position/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, PositionResource, name, value, '/position/list', 
        fields, 'id', 'position_name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def bpersons_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/bperson/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/bperson/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/bperson/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, BPersonResource, name, value, '/bperson/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def hotelcats_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200}
    ]]
    tools = (
        tool('add', '/hotelcat/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/hotelcat/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/hotelcat/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, HotelcatResource, name, value, '/hotelcat/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def accomodations_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200}
    ]]
    tools = (
        tool('add', '/accomodation/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/accomodation/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/accomodation/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, AccomodationResource, name, value, '/accomodation/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def yes_no_field(name, value=None, data_options=None, **kwargs):
    choices = [
        (0, _(u'no')),
        (1, _(u'yes')),
    ]
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += (',%s' % data_options)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options=_data_options, **kwargs
    )


def structures_combotree_field(
    name, value=None, data_options=None, **kwargs
):
    return _combotree_field(
        name, value, '/structure/list', 'structure_name', 'asc',
        data_options, **kwargs
    )


def accounts_items_combotree_field(
    name, value=None, data_options=None, **kwargs
):
    return _combotree_field(
        name, value, '/account_item/list', 'name', 'asc',
        data_options, **kwargs
    )


def permisions_yes_no_field(
    name, value, permision, data_options=None, **kwargs
):
    choices = [
        ("", _(u'no')),
        (permision, _(u'yes')),
    ]
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ',%s' % data_options
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options=_data_options, **kwargs
    )


def navigations_combotree_field(
    name, position_id, value=None, data_options=None, **kwargs
):
    _data_options = """
        url: '/navigation/list',
        onBeforeLoad: function(node, param){
            param.position_id = %s;
            param.sort = 'sort_order';
            param.order = 'asc';
    """ % position_id
    if value:
        _data_options += """
            if(!node){
                param.id = %s;
                param.with_chain = true;
            }
        """ % value

    _data_options += """
        }
    """
    if value:
        _data_options += """,
            onLoadSuccess: function(node, data){
                if(!node){
                    var n = $(this).tree('find', %s);
                    $(this).tree('expandTo', n.target);
                    $(this).tree('scrollTo', n.target);
                }
            }
        """ % value
    if data_options:
        _data_options += ',%s' % data_options

    return tags.text(
        name, value, class_="easyui-combotree text w20",
        data_options=_data_options, **kwargs
    )


def permisions_scope_type_field(
    name, value, data_options=None, **kwargs
):
    choices = [
        ("all", _(u'all')),
        ("structure", _(u'structure')),
    ]
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ',%s' % data_options
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def date_field(name, value=None, data_options=None, **kwargs):
    id = gen_id()
    _data_options = """
        editable:false,
        formatter:function(date){return dt_formatter(date, %s);},
        parser:function(s){return dt_parser(s, %s);}
        """ % (
       json.dumps(get_date_format()),
       json.dumps(get_date_format())
    )
    if data_options:
        _data_options += ",%s" % data_options
    if value:
        value = format_date(value)
    html = tags.text(
        name, value, class_="easyui-datebox text w10",
        id=id, data_options=_data_options, **kwargs
    )
    return html + HTML.literal("""
        <script type="text/javascript">
            add_datebox_clear_btn("#%s");
        </script>
    """) % id


def datetime_field(name, value=None, data_options=None, **kwargs):
    id = gen_id()
    _data_options = """
        editable:false,
        showSeconds:false,
        formatter:function(date){return dt_formatter(date, %s);},
        parser:function(s){return dt_parser(s, %s);}
        """ % (
            json.dumps(get_datetime_format()),
            json.dumps(get_datetime_format())
        )
    if data_options:
        _data_options += ",%s" % data_options
    if value:
        value = format_datetime(value)
    html = tags.text(
        name, value, class_="easyui-datetimebox text w10",
        id=id, data_options=_data_options, **kwargs
    )
    return html + HTML.literal("""
        <script type="text/javascript">
            add_datetimebox_clear_btn("#%s");
        </script>
    """) % id


def gender_combobox_field(name, value=None, data_options=None, **kwargs):
    choices = [('', '--None--'),] + list(Person.GENDER)
    _data_options = "panelHeight:'auto',editable:false,width:126"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def contact_type_combobox_field(name, value=None, data_options=None, **kwargs):
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, Contact.CONTACT_TYPE,
        class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def countries_combogrid_field(
    request, name, value=None, 
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'country_name',
            'title': _(u"name"),
            'sortable': True, 'width': 200}
    ]]
    tools = (
        tool('add', '/country/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/country/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/country/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, CountryResource, name, value, '/country/list', 
        fields, 'id', 'country_name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def regions_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'full_region_name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]
    tools = (
        tool('add', '/region/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/region/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/region/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, RegionResource, name, value, '/country/list', 
        fields, 'id', 'full_region_name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def locations_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'full_location_name',
            'title': _(u"name"),
            'sortable': True, 'width': 100},
    ]]
    tools = (
        tool('add', '/location/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/location/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/location/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, LocationResource, name, value, '/location/list', 
        fields, 'id', 'full_location_name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def suppliers_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]
    tools = (
        tool('add', '/supplier/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/supplier/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/supplier/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, SupplierResource, name, value, '/supplier/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def foodcats_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]
    tools = (
        tool('add', '/foodcat/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/foodcat/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/foodcat/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, FoodcatResource, name, value, '/foodcat/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def roomcats_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]
    tools = (
        tool('add', '/roomcat/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/roomcat/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/roomcat/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, RoomcatResource, name, value, '/roomcat/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def hotels_combogrid_field(
    request, name, value=None, 
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'full_hotel_name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]
    tools = (
        tool('add', '/hotel/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/hotel/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/hotel/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, HotelResource, name, value, '/hotel/list', 
        fields, 'id', 'full_hotel_name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def currencies_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'iso_code',
            'title': _(u"iso code"),
            'sortable': True, 'width': 100},
    ]]
    tools = (
        tool('add', '/currency/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/currency/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/currency/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, CurrencyResource, name, value, '/currency/list', 
        fields, 'id', 'iso_code', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def persons_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/person/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/person/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/person/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, PersonResource, name, value, '/person/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def advsources_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/advsource/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/advsource/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/advsource/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, AdvsourceResource, name, value, '/advsource/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def passport_type_field(name, value=None, data_options=None, **kwargs):
    _data_options="panelHeight:'auto',editable:false,width:246"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, Passport.PASSPORT_TYPE, class_='easyui-combobox text w20',
        data_options=_data_options, **kwargs
    )


def banks_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/bank/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/bank/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/bank/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, BankResource, name, value, '/bank/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def services_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/service/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/service/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/service/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, ServiceResource, name, value, '/service/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def accounts_types_combobox_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false,width:126"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, Account.ACCOUNTS_TYPES, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def accounts_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/account/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/account/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/account/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, AccountResource, name, value, '/account/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def invoices_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = """[[{
        field: 'customer', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return '<span class="b">' + value + '</span></br><span>%(sum)s: '
            + row.currency + ' ' + row.sum + '</span><br/>' +
            '<span>%(id)s: ' + row.id +
            ' %(from_date)s: ' + row.date + '</span>';
        }
    }]]""" % {
        'title': _(u'customer'),
        'sum': _(u'sum'),
        'id': _(u'num'),
        'from_date': _(u'from date'),
    }
    tools = (
        tool('view', '/invoice/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/invoice/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, InvoiceResource, name, value, '/invoice/list', 
        fields, 'id', 'customer', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def subaccounts_types_combobox_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = [
        (rt.name, rt.humanize)
        for rt in get_subaccounts_types()
    ]
    return tags.select(
        name, value, choices,
        class_='easyui-combobox text w20',
        data_options=_data_options, **kwargs
    )


def subaccounts_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = """[[{
        field: 'title', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return '<span class="b">' + value + '</span></br>' + 
            '<span>%(name)s: ' + row.name + '</span><br/>' +
            '<span>%(resource_type)s: ' + row.resource_type + '</span>';
        }
    }]]""" % {
        'title': _(u'name'),
        'name': _(u'name'),
        'resource_type': _(u'resource'),
    }
    tools = (
        tool('add', '/subaccount/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/subaccount/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/subaccount/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, SubaccountResource, name, value, '/subaccount/list', 
        fields, 'id', 'title', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def timezones_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options="panelHeight:'120',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = [tz for tz in common_timezones]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w20',
        data_options=_data_options, **kwargs
    )


def locales_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = [
        (u'en', _(u'en')),
        (u'ru', _(u'ru')),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options=_data_options, **kwargs
    )


def resources_types_statuses_combobox_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false,width:126"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, ResourceType.STATUS, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def tasks_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = Task.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def notifications_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = EmployeeNotification.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def leads_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = Lead.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def services_types_combobox_field(name, value=None):
    ids = map(
        lambda x: str(x.id), get_resources_types_by_interface(IServiceType)
    )
    data_options = """
        url: '/resource_type/list',
        valueField: 'id',
        textField: 'humanize',
        editable: false,
        onBeforeLoad: function(param){
            param.sort = 'humanize';
            param.rows = 0;
            param.page = 1;
            param.id = %s
        },
        loadFilter: function(data){
            return data.rows;
        }
    """ % json.dumps(','.join(ids))
    return tags.text(
        name, value, class_="easyui-combobox text w20",
        data_options=data_options
    )


def transfers_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/subaccount/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/subaccount/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/subaccount/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, TransferResource, name, value, '/subaccount/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field


def transports_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/transport/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/transport/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/transport/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, TransportResource, name, value, '/transport/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def orders_items_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None
):
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = OrderItem.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options
    )


def tasks_reminders_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = [(t, t) for t in range(10, 70, 10)]
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options=_data_options, **kwargs
    )


def accounts_items_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = AccountItem.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def accounts_items_types_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = AccountItem.TYPE
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )

def suppliers_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = Supplier.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )
