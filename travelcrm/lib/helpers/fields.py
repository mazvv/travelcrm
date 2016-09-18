# -*coding: utf-8-*-

from collections import namedtuple

from pytz import common_timezones
from webhelpers2.html import tags
from webhelpers2.html import HTML

from ...interfaces import IServiceType
from ...resources.accomodations import AccomodationsResource
from ...resources.employees import EmployeesResource
from ...resources.positions import PositionsResource
from ...resources.bpersons import BPersonsResource
from ...resources.hotelcats import HotelcatsResource
from ...resources.countries import CountriesResource
from ...resources.regions import RegionsResource
from ...resources.locations import LocationsResource
from ...resources.suppliers import SuppliersResource
from ...resources.roomcats import RoomcatsResource
from ...resources.foodcats import FoodcatsResource
from ...resources.hotels import HotelsResource
from ...resources.currencies import CurrenciesResource
from ...resources.persons import PersonsResource
from ...resources.advsources import AdvsourcesResource
from ...resources.banks import BanksResource
from ...resources.services import ServicesResource
from ...resources.accounts import AccountsResource
from ...resources.invoices import InvoicesResource
from ...resources.subaccounts import SubaccountsResource
from ...resources.transfers import TransfersResource
from ...resources.transports import TransportsResource
from ...resources.suppliers_types import SuppliersTypesResource
from ...resources.tickets_classes import TicketsClassesResource
from ...resources.leads import LeadsResource
from ...resources.orders import OrdersResource
from ...resources.companies import CompaniesResource
from ...resources.persons_categories import PersonsCategoriesResource
from ...resources.tags import TagsResource
from ...resources.mails import MailsResource

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
from ...models.contract import Contract
from ...models.bperson import BPerson
from ...models.visa import Visa
from ...models.lead_offer import LeadOffer
from ...models.order import Order
from ...models.vat import Vat
from ...models.campaign import Campaign

from ..utils.common_utils import (
    gen_id,
    get_date_format,
    get_datetime_format,
    format_date,
    format_datetime,
    jsonify,
)
from ..utils.common_utils import translate as _
from ..utils.common_utils import get_available_locales
from ..utils.resources_utils import get_resources_types_by_interface
from ..bl.subaccounts import get_subaccounts_types
from ..bl.tarifs import get_tarifs_list


tool = namedtuple('tool', ('name', 'url', 'icon', 'title', 'with_row'))


class _Option(tags.Option):
    """private Option class for backward compatible 
    """
    def __init__(self, value=None, label=None):
        super(_Option, self).__init__(label, value)


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
            'id': jsonify(self._value),
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
        data_options = """
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
                jsonify(self._fields) 
                if not isinstance(self._fields, basestring) 
                else self._fields
            ),
            'id': jsonify(self._value),
            'obj_id': self._id,
            'on_before_load': self._render_on_before_load(),
            'on_success_load': self._render_on_load_success()
        })
        if self._data_options:
            data_options += ('%s' % self._data_options)
        return data_options

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
        tool('add', '/employees/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/employees/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/employees/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, EmployeesResource, name, value, '/employees/list', 
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
            return value + '<br/>'
            + '<em>' + row.structure_path.join(' &rarr; ') + '</em>';
        }
    }]]""" % {'title': _(u'name')}
    tools = (
        tool('add', '/positions/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/positions/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/positions/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, PositionsResource, name, value, '/positions/list', 
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
        tool('add', '/bpersons/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/bpersons/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/bpersons/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, BPersonsResource, name, value, '/bpersons/list', 
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
        tool('add', '/hotelcats/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/hotelcats/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/hotelcats/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, HotelcatsResource, name, value, '/hotelcats/list', 
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
        tool('add', '/accomodations/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/accomodations/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/accomodations/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, AccomodationsResource, name, value, '/accomodations/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def yes_no_field(name, value=None, data_options=None, **kwargs):
    choices = [
        _Option(0, _(u'no')),
        _Option(1, _(u'yes')),
    ]
    _data_options = "panelHeight:'auto',editable:false"
    if data_options:
        _data_options += (',%s' % data_options)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options=_data_options, **kwargs
    )


def switch_field(name, value=None, data_options=None, **kwargs):
    _data_options = ""
    if data_options:
        _data_options += ('%s' % data_options)
    return tags.checkbox(
        name, True, bool(value), class_='easyui-switchbutton',
        data_options=_data_options, **kwargs
    )


def structures_combotree_field(
    name, value=None, data_options=None, **kwargs
):
    return _combotree_field(
        name, value, '/structures/list', 'structure_name', 'asc',
        data_options, **kwargs
    )


def accounts_items_combotree_field(
    name, value=None, data_options=None, **kwargs
):
    return _combotree_field(
        name, value, '/accounts_items/list', 'name', 'asc',
        data_options, **kwargs
    )


def permisions_switch_field(
    name, value, permision, data_options=None, **kwargs
):
    _data_options = ""
    if data_options:
        _data_options += ('%s' % data_options)
    return tags.checkbox(
        name, permision, value == permision, class_='easyui-switchbutton',
        data_options=_data_options, **kwargs
    )


def permisions_yes_no_field(
    name, value, permision, data_options=None, **kwargs
):
    choices = [
        _Option("", _(u'no')),
        _Option(permision, _(u'yes')),
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
        url: '/navigations/list',
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
        _Option("all", _(u'all')),
        _Option("structure", _(u'structure')),
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
    format = get_date_format()
    
    # this hack is need for datebox correct working
    format = format.replace('yy', 'yyyy')

    _data_options = """
        editable:false,
        formatter:function(date){return dt_formatter(date, %s);},
        parser:function(s){return dt_parser(s, %s);}
        """ % (
       jsonify(format),
       jsonify(format)
    )
    if data_options:
        _data_options += ",%s" % data_options
    if value:
        value = format_date(value, format)
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
            jsonify(get_datetime_format()),
            jsonify(get_datetime_format())
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
    choices = (
        [_Option('', '--None--'),]
        + list(map(lambda x: _Option(*x), Person.GENDER))
    )
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
        name, value, map(lambda x: _Option(*x), Contact.CONTACT_TYPE),
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
        tool('add', '/countries/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/countries/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/countries/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, CountriesResource, name, value, '/countries/list', 
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
        tool('add', '/regions/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/regions/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/regions/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, RegionsResource, name, value, '/regions/list', 
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
        tool('add', '/locations/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/locations/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/locations/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, LocationsResource, name, value, '/locations/list', 
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
        tool('add', '/suppliers/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/suppliers/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/suppliers/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, SuppliersResource, name, value, '/suppliers/list', 
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
        tool('add', '/foodcats/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/foodcats/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/foodcats/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, FoodcatsResource, name, value, '/foodcats/list', 
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
        tool('add', '/roomcats/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/roomcats/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/roomcats/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, RoomcatsResource, name, value, '/roomcats/list', 
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
        tool('add', '/hotels/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/hotels/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/hotels/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, HotelsResource, name, value, '/hotels/list', 
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
        tool('add', '/currencies/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/currencies/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/currencies/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, CurrenciesResource, name, value, '/currencies/list', 
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
        tool('add', '/persons/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/persons/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/persons/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, PersonsResource, name, value, '/persons/list', 
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
        tool('add', '/advsources/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/advsources/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/advsources/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, AdvsourcesResource, name, value, '/advsources/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def passport_type_field(name, value=None, data_options=None, **kwargs):
    _data_options="panelHeight:'auto',editable:false,width:246"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, map(lambda x: _Option(*x), Passport.PASSPORT_TYPE),
        class_='easyui-combobox text w20',
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
        tool('add', '/banks/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/banks/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/banks/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, BanksResource, name, value, '/banks/list', 
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
        tool('add', '/services/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/services/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/services/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, ServicesResource, name, value, '/services/list', 
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
        name, value, map(lambda x: _Option(*x), Account.ACCOUNTS_TYPES),
        class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def accounts_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = """[[{
        field: 'name', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return value + '<br/>'
            + '<div class="dp100"><div class="dp70"><em>' 
            + row.account_type.title + ' ' + row.currency 
            + '</em></div><div class="dp30 tr">'
            + status_formatter(row.status) + '</div></div>';
        }
    }]]""" % {'title': _(u'name')}

    tools = (
        tool('add', '/accounts/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/accounts/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/accounts/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, AccountsResource, name, value, '/accounts/list', 
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
            + row.currency + ' ' + row.final_price + '</span><br/>' +
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
        tool('add', '/invoices/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/invoices/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/invoices/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, InvoicesResource, name, value, '/invoices/list', 
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
        _Option(rt.name, rt.humanize)
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
        tool('add', '/subaccounts/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/subaccounts/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/subaccounts/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, SubaccountsResource, name, value, '/subaccounts/list', 
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
        _Option(item, item) for item in get_available_locales()
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
        name, value, map(lambda x: _Option(*x), ResourceType.STATUS),
        class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def tasks_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), Task.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
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
    choices = map(lambda x: _Option(*x), EmployeeNotification.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
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
    choices = map(lambda x: _Option(*x), Lead.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def services_types_combobox_field(name, value=None):
    ids = map(
        lambda x: str(x.id), get_resources_types_by_interface(IServiceType)
    )
    data_options = """
        url: '/resources_types/list',
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
    """ % jsonify(','.join(ids))
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
        tool('add', '/transfers/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/transfers/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/transfers/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, TransfersResource, name, value, '/transfers/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def transports_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/transports/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/transports/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/transports/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, TransportsResource, name, value, '/transports/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()



def tickets_classes_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/tickets_classes/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/tickets_classes/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/tickets_classes/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, TicketsClassesResource, name, value, '/tickets_classes/list', 
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
    choices = map(lambda x: _Option(*x), OrderItem.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
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
    choices = [_Option(t, t) for t in range(10, 70, 10)]
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
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
    choices = map(lambda x: _Option(*x), AccountItem.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
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
    choices = map(lambda x: _Option(*x), AccountItem.TYPE)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
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
    choices = map(lambda x: _Option(*x), Supplier.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def suppliers_types_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/suppliers_types/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/suppliers_types/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/suppliers_types/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, SuppliersTypesResource, name, value, '/suppliers_types/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def contracts_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), Contract.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def bpersons_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), BPerson.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def visas_types_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), Visa.TYPE)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def leads_offers_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), LeadOffer.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def leads_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = """[[{
        field: 'customer', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return value + '<br/>'
            + '<em>id ' + row.id + ' %(from_date)s ' + row.lead_date + '</em>';
        }
    }]]""" % {'title': _(u'customer'), 'from_date': _(u'from')}

    tools = (
        tool('add', '/leads/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/leads/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/leads/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, LeadsResource, name, value, '/leads/list', 
        fields, 'id', 'customer', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def orders_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = """[[{
        field: 'customer', title: '%(title)s',
        formatter: function(value,row,index){
            return value + '<br/>'
            + '<em>id ' + row.id + ' %(from_date)s ' + row.deal_date + '</em>';
        },
        sortable: true, width: 200,
    }]]""" % {
        'title': _(u'customer'),
        'from_date': _(u'from')
    }

    tools = (
        tool('add', '/orders/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/orders/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/orders/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, OrdersResource, name, value, '/orders/list', 
        fields, 'id', 'customer', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def accounts_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), Account.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def orders_statuses_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), Order.STATUS)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def companies_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]
    tools = (
        tool('view', '/companies/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/companies/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, CompaniesResource, name, value, '/companies/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def vats_calc_methods_combobox_field(
    name, value=None, with_all=False, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = map(lambda x: _Option(*x), Vat.CALC_METHOD)
    if with_all:
        choices = [_Option('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def persons_categories_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/persons_categories/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/persons_categories/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/persons_categories/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, PersonsCategoriesResource, name, value, '/persons_categories/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def campaigns_statuses_combobox_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false,width:126"
    if data_options:
        _data_options += ",%s" % data_options
    return tags.select(
        name, value, map(lambda x: _Option(*x), Campaign.STATUS),
        class_='easyui-combobox text w10',
        data_options=_data_options, **kwargs
    )


def tarifs_combobox_field(
    name, value=None, data_options=None, **kwargs
):
    _data_options="panelHeight:'auto',editable:false"
    if data_options:
        _data_options += ",%s" % data_options
    choices = [item[:2] for item in get_tarifs_list()]
    return tags.select(
        name, value, map(lambda x: _Option(*x), choices),
        class_='easyui-combobox text w20',
        data_options=_data_options, **kwargs
    )


def tags_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/tags/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/tags/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/tags/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, TagsResource, name, value, '/tags/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()


def mails_combogrid_field(
    request, name, value=None,
    id=None, show_toolbar=True, data_options=None, **kwargs
):
    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    tools = (
        tool('add', '/mails/add', 'fa-plus', _(u'add new'), False),
        tool('view', '/mails/view', 'fa-circle-o', _(u'view item'), True),
        tool('edit', '/mails/edit', 'fa-pencil', _(u'edit item'), True)
    )
    field = _ComboGridField(
        request, MailsResource, name, value, '/mails/list', 
        fields, 'id', 'name', tools, id, show_toolbar, 
        data_options, **kwargs
    )
    return field()
