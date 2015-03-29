# -*coding: utf-8-*-

import json
from pytz import common_timezones

from webhelpers.html import tags
from webhelpers.html import HTML

from ...interfaces import IServiceType
from ...resources.employee import EmployeeResource
from ...resources.position import PositionResource
from ...resources.licence import LicenceResource
from ...resources.bperson import BPersonResource
from ...resources.contact import ContactResource
from ...resources.hotelcat import HotelcatResource
from ...resources.country import CountryResource
from ...resources.region import RegionResource
from ...resources.location import LocationResource
from ...resources.touroperator import TouroperatorResource
from ...resources.accomodation_type import AccomodationTypeResource
from ...resources.roomcat import RoomcatResource
from ...resources.foodcat import FoodcatResource
from ...resources.hotel import HotelResource
from ...resources.currency import CurrencyResource
from ...resources.person import PersonResource
from ...resources.advsource import AdvsourceResource
from ...resources.bank import BankResource
from ...resources.bank_detail import BankDetailResource
from ...resources.service import ServiceResource
from ...resources.account_item import AccountItemResource
from ...resources.account import AccountResource
from ...resources.invoice import InvoiceResource
from ...resources.supplier import SupplierResource
from ...resources.subaccount import SubaccountResource

from ...models.task import Task
from ...models.account import Account
from ...models.resource_type import ResourceType
from ...models.contact import Contact
from ...models.person import Person
from ...models.passport import Passport
from ...models.notification import EmployeeNotification
from ...models.lead import Lead

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


def yes_no_field(value=None, name='yes_no', **kwargs):
    choices = [
        (0, _(u'no')),
        (1, _(u'yes')),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto',editable:false",
        **kwargs
    )


def structures_combotree_field(
    value=None, name='parent_id', options=None
):
    data_options = """
        url: '/structure/list',
        onBeforeLoad: function(node, param){
            param.sort = 'structure_name';
    """
    if value:
        data_options += """
            if(!node){
                param.id = %s;
                param.with_chain = true;
            }
        """ % value

    data_options += """
        }
    """
    if value:
        data_options += """,
            onLoadSuccess: function(node, data){
                if(!node){
                    var n = $(this).tree('find', %s);
                    $(this).tree('expandTo', n.target);
                    $(this).tree('scrollTo', n.target);
                }
            }
        """ % value
    if options:
        data_options += """,
            %s
        """ % options

    return tags.text(name, value, class_="easyui-combotree text w20",
                     data_options=data_options
                     )


def resources_types_combobox_field(
    value=None, name='resource_type_id'
):
    data_options = """
        url: '/resource_type/list',
        valueField: 'id',
        textField: 'humanize',
        editable: false,
        onBeforeLoad: function(param){
            param.sort = 'humanize';
            param.rows = 0;
            param.page = 1;
        },
        loadFilter: function(data){
            return data.rows;
        }
    """
    return tags.text(
        name, value, class_="easyui-combobox text w20",
        data_options=data_options
    )


def permisions_yes_no_field(value=None, permision="view", name='permisions'):
    choices = [
        ("", _(u'no')),
        (permision, _(u'yes')),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto',editable:false"
    )


def navigations_combotree_field(
    position_id, value=None, name='parent_id'
):
    data_options = """
        url: '/navigation/list',
        onBeforeLoad: function(node, param){
            param.position_id = %s;
            param.sort = 'sort_order';
    """ % position_id
    if value:
        data_options += """
            if(!node){
                param.id = %s;
                param.with_chain = true;
            }
        """ % value

    data_options += """
        }
    """
    if value:
        data_options += """,
            onLoadSuccess: function(node, data){
                if(!node){
                    var n = $(this).tree('find', %s);
                    $(this).tree('expandTo', n.target);
                    $(this).tree('scrollTo', n.target);
                }
            }
        """ % value

    return tags.text(
        name, value, class_="easyui-combotree text w20",
        data_options=data_options
    )


def employees_combobox_field(
    request, value=None, name='employee_id',
    id=None, show_toolbar=True, options=None
):
    permisions = EmployeeResource.get_permisions(EmployeeResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/employee/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/employee/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/employee/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'name', 'title': _(u"name"), 'sortable': True, 'width': 200}
    ]]

    data_options = """
        url: '/employee/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def positions_combogrid_field(
    request, value=None, name='position_id',
    id=None, show_toolbar=True, options=None
):
    permisions = PositionResource.get_permisions(PositionResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/position/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/position/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/position/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = """[[{
        field: 'position_name', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return '<span class="b">' + value + '</span><br/>'
            + row.structure_path.join(' &rarr; ');
        }
    }]]""" % {'title': _(u'name')}

    data_options = """
        url: '/position/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'position_name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': fields,
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def permisions_scope_type_field(
    value='structure', name='scope_type', options=None
):
    choices = [
        ("all", _(u'all')),
        ("structure", _(u'structure')),
    ]
    data_options = "panelHeight:'auto',editable:false"
    if options:
        data_options += ',%s' % options
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=data_options
    )


def date_field(value, name, options=None):
    id = gen_id()
    data_options = """
        editable:false,
        formatter:function(date){return dt_formatter(date, %s);},
        parser:function(s){return dt_parser(s, %s);}
        """ % (
       json.dumps(get_date_format()),
       json.dumps(get_date_format())
    )
    if options:
        data_options += ",%s" % options
    if value:
        value = format_date(value)
    html = tags.text(
        name, value, class_="easyui-datebox text w10",
        id=id, **{'data-options': data_options}
    )
    return html + HTML.literal("""
        <script type="text/javascript">
            add_datebox_clear_btn("#%s");
        </script>
    """) % id


def time_field(value, name, options=None):
    id = gen_id()
    data_options = "showSeconds:false,width:60"
    if options:
        data_options += ",%s" % options
    if value:
        value = format_date(value)
    html = tags.text(
        name, value, class_="easyui-timespinner text w10",
        id=id, **{'data-options': data_options}
    )
    return html


def datetime_field(value, name, options=None):
    id = gen_id()
    data_options = """
        editable:false,
        showSeconds:false,
        formatter:function(date){return dt_formatter(date, %s);},
        parser:function(s){return dt_parser(s, %s);}
        """ % (
            json.dumps(get_datetime_format()),
            json.dumps(get_datetime_format())
        )
    if options:
        data_options += ",%s" % options
    if value:
        value = format_datetime(value)
    html = tags.text(
        name, value, class_="easyui-datetimebox text w10",
        id=id, **{'data-options': data_options}
    )
    return html + HTML.literal("""
        <script type="text/javascript">
            add_datetimebox_clear_btn("#%s");
        </script>
    """) % id


def gender_combobox_field(
    value=None, name='gender'
):
    choices = [('', '--None--'),] + list(Person.GENDER)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false,width:126"
    )


def contact_type_combobox_field(
    value=None, name='contact_type'
):
    return tags.select(
        name, value, Contact.CONTACT_TYPE,
        class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false"
    )


def licences_combobox_field(
    request, value=None, name='licence_id',
    id=None, show_toolbar=True, options=None
):
    permisions = LicenceResource.get_permisions(LicenceResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/licence/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/licence/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/licence/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'licence_num', 'title': _(u"licence num"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/licence/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'licence_num',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def bpersons_combobox_field(
    request, value=None, name='bperson_id',
    id=None, show_toolbar=True, options=None
):
    permisions = BPersonResource.get_permisions(BPersonResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bperson/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bperson/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bperson/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/bperson/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def contacts_combobox_field(
    request, value=None, name='contact_id',
    id=None, show_toolbar=True, options=None
):
    permisions = ContactResource.get_permisions(ContactResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/contact/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/contact/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/contact/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'contact',
            'title': _(u"contact"),
            'sortable': True, 'width': 200}
    ]]

    data_options = """
        url: '/contact/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'contact',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def hotelcats_combobox_field(
    request, value=None, name='hotelcat_id',
    id=None, show_toolbar=True, options=None
):
    permisions = HotelcatResource.get_permisions(HotelcatResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotelcat/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotelcat/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotelcat/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200}
    ]]

    data_options = """
        url: '/hotelcat/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def countries_combobox_field(
    request, value=None, name='country_id',
    id=None, show_toolbar=True, options=None
):
    permisions = CountryResource.get_permisions(CountryResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/country/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/country/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/country/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'country_name',
            'title': _(u"name"),
            'sortable': True, 'width': 200}
    ]]

    data_options = """
        url: '/country/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'country_name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def regions_combobox_field(
    request, value=None, name='region_id',
    id=None, show_toolbar=True, options=None
):
    permisions = RegionResource.get_permisions(RegionResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/region/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/region/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/region/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'full_region_name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]

    data_options = """
        url: '/region/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'full_region_name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def locations_combobox_field(
    request, value=None, name='location_id',
    id=None, show_toolbar=True, options=None
):
    permisions = LocationResource.get_permisions(LocationResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/location/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/location/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/location/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'full_location_name',
            'title': _(u"name"),
            'sortable': True, 'width': 100},
    ]]

    data_options = """
        url: '/location/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'full_location_name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def touroperators_combobox_field(
    request, value=None, name='touroperator_id',
    id=None, show_toolbar=True, options=None
):
    permisions = TouroperatorResource.get_permisions(
        TouroperatorResource, request
    )
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/touroperator/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/touroperator/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/touroperator/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]

    data_options = """
        url: '/touroperator/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def accomodations_types_combobox_field(
    request, value=None, name='accomodation_type_id',
    id=None, show_toolbar=True, options=None
):
    permisions = AccomodationTypeResource.get_permisions(
        AccomodationTypeResource, request
    )
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',"
                "url:'/accomodation_type/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',"
                "url:'/accomodation_type/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',"
                "url:'/accomodation_type/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]

    data_options = """
        url: '/accomodation_type/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def foodcats_combobox_field(
    request, value=None, name='foodcat_id',
    id=None, show_toolbar=True, options=None
):
    permisions = FoodcatResource.get_permisions(FoodcatResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/foodcat/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/foodcat/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/foodcat/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]

    data_options = """
        url: '/foodcat/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def roomcats_combobox_field(
    request, value=None, name='roomcat_id',
    id=None, show_toolbar=True, options=None
):
    permisions = RoomcatResource.get_permisions(RoomcatResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/roomcat/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/roomcat/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/roomcat/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]

    data_options = """
        url: '/roomcat/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def hotels_combobox_field(
    request, value=None, name='hotel_id',
    id=None, show_toolbar=True, options=None
):
    permisions = HotelResource.get_permisions(HotelResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotel/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotel/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotel/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'full_hotel_name',
            'title': _(u"name"),
            'sortable': True, 'width': 200},
    ]]

    data_options = """
        url: '/hotel/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'full_hotel_name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def currencies_combobox_field(
    request, value=None, name='currency_id',
    id=None, show_toolbar=True, options=None
):
    permisions = CurrencyResource.get_permisions(CurrencyResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/currency/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/currency/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/currency/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[
        {'field': 'iso_code',
            'title': _(u"iso code"),
            'sortable': True, 'width': 100},
    ]]

    data_options = """
        url: '/currency/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'iso_code',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def persons_combobox_field(
    request, value=None, name='person_id',
    id=None, show_toolbar=True, options=None
):
    permisions = PersonResource.get_permisions(PersonResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/person/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/person/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/person/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/person/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def advsources_combobox_field(
    request, value=None, name='advsource_id',
    id=None, show_toolbar=True, options=None
):
    permisions = AdvsourceResource.get_permisions(AdvsourceResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/advsource/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/advsource/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/advsource/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/advsource/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def passport_type_field(
    value=None, name='passport_type'
):
    return tags.select(
        name, value, Passport.PASSPORT_TYPE, class_='easyui-combobox text w20',
        data_options="panelHeight:'auto',editable:false,width:246"
    )


def tasks_status_combobox_field(
    value=None, name='status'
):
    return tags.select(
        name, value, Task.STATUS, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false,width:126"
    )


def banks_combobox_field(
    request, value=None, name='bank_id',
    id=None, show_toolbar=True, options=None
):
    permisions = BankResource.get_permisions(BankResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bank/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bank/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bank/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/bank/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def banks_details_combobox_field(
    request, value=None, name='bank_detail_id',
    id=None, show_toolbar=True,
    structure_id=False, options=None
):
    permisions = BankDetailResource.get_permisions(BankDetailResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bank_detail/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bank_detail/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bank_detail/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )
    fields = """[[{
        field: 'bank_name', title: '%(title)s',
        sortable: true, width: 200,
        formatter: function(value,row,index){
            return '<span class="b">' + value + ' '
            + row.currency + '</span><br/>' +
            '<span>%(beneficiary)s: ' + row.beneficiary
            + '<br/>%(account)s: ' + row.account
            + '<br/>%(swift)s: ' + row.swift_code + '</span>';
        }
    }]]""" % {
        'title': _(u'name'),
        'beneficiary': _(u'beneficiary'),
        'account': _(u'account'),
        'swift': _(u'swift'),
    }

    data_options = """
        url: '/bank_detail/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'bank_name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
        onBeforeLoad: function(param){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            var id = %(id)s;
            if(response_id){
                param.id = response_id;
                if(%(structure_id)s){
                    param.structure_id = %(structure_id)s;
                }
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': fields,
        'id': json.dumps(value),
        'obj_id': obj_id,
        'structure_id': json.dumps(structure_id),
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def services_combobox_field(
    request, value=None, name='service_id',
    id=None, show_toolbar=True, options=None,
):
    permisions = ServiceResource.get_permisions(ServiceResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/service/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/service/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/service/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]
    data_options = """
        url: '/service/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def accounts_items_combobox_field(
    request, value=None, name='account_item_id',
    id=None, show_toolbar=True, options=None
):
    permisions = AccountItemResource.get_permisions(
        AccountItemResource, request
    )
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/account_item/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/account_item/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/account_item/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/account_item/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def accounts_types_combobox_field(
    value=None, name='account_type'
):
    return tags.select(
        name, value, Account.ACCOUNTS_TYPES, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false,width:126"
    )


def accounts_combobox_field(
    request, value=None, name='account_id',
    id=None, show_toolbar=True, options=None,
):
    permisions = AccountResource.get_permisions(AccountResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/account/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/account/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/account/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/account/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def invoices_combobox_field(
    request, value=None, name='invoice_id',
    id=None, show_toolbar=True, options=None
):
    permisions = InvoiceResource.get_permisions(InvoiceResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/invoice/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/invoice/info',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-info easyui-tooltip _action',
                title=_(u'info'),
                **kwargs
            )
        )

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

    data_options = """
        url: '/invoice/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'customer',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': fields,
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def subaccounts_types_combobox_field(
    value=None, name='subaccount_type', options=None,
):
    data_options = "panelHeight:'auto',editable:false"
    if options:
        data_options += """,
            %s
        """ % options
    choices = [
        (rt.name, rt.humanize)
        for rt in get_subaccounts_types()
    ]
    return tags.select(
        name, value, choices,
        class_='easyui-combobox text w20',
        data_options=data_options
    )


def suppliers_combobox_field(
    request, value=None, name='supplier_id',
    id=None, show_toolbar=True, options=None,
):
    permisions = SupplierResource.get_permisions(SupplierResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/supplier/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/supplier/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/supplier/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

    fields = [[{
        'field': 'name', 'title': _(u"name"),
        'sortable': True, 'width': 200
    }]]

    data_options = """
        url: '/supplier/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'name',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def subaccounts_combobox_field(
    request, value=None, name='subaccount_id',
    id=None, show_toolbar=True, options=None,
):
    permisions = SubaccountResource.get_permisions(SubaccountResource, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/subaccount/add'"
                % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-plus easyui-tooltip _action',
                title=_(u'add new'),
                **kwargs
            )
        )
    if 'view' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/subaccount/view',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-circle-o easyui-tooltip _action',
                title=_(u'view item'),
                **kwargs
            )
        )
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/subaccount/edit',"
                "property:'with_row'" % obj_id
        }
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='fa fa-pencil easyui-tooltip _action',
                title=_(u'edit selected'),
                **kwargs
            )
        )

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

    data_options = """
        url: '/subaccount/list',
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'title',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: false,
        view: bufferview,
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
        onLoadSuccess: function(){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            if(response_id){
                $(this_selector).combogrid('clear');
                $(this_selector).combogrid('setValue', response_id);
                $(this_selector).data('response', '');
            }
        }
    """ % ({
        'columns': fields,
        'id': json.dumps(value),
        'obj_id': obj_id,
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'span', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if (toolbar and show_toolbar) else ''
    )


def timezones_field(value=None, name='timezone', **kwargs):
    choices = [tz for tz in common_timezones]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w20',
        data_options="panelHeight:'120',editable:false",
        **kwargs
    )


def locales_field(value=None, name='locale', **kwargs):
    choices = [
        (u'en', _(u'en')),
        (u'ru', _(u'ru')),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto',editable:false",
        **kwargs
    )


def resources_types_statuses_combobox_field(
    value=None, name='status'
):
    return tags.select(
        name, value, ResourceType.STATUS, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false,width:126"
    )


def tasks_statuses_combobox_field(
    value=None, name='status', with_all=False, options=None
):
    data_options = "panelHeight:'auto',editable:false"
    if options:
        data_options += """,
            %s
        """ % options
    choices = Task.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=data_options
    )


def notifications_statuses_combobox_field(
    value=None, name='status', with_all=False, options=None
):
    data_options = "panelHeight:'auto',editable:false"
    if options:
        data_options += """,
            %s
        """ % options
    choices = EmployeeNotification.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=data_options
    )


def leads_statuses_combobox_field(
    value=None, name='status', with_all=False, options=None
):
    data_options = "panelHeight:'auto',editable:false"
    if options:
        data_options += """,
            %s
        """ % options
    choices = Lead.STATUS
    if with_all:
        choices = [('', _(u'--all--'))] + list(choices)
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options=data_options
    )


def services_types_combobox_field(
    value=None, name='resource_type_id'
):
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
