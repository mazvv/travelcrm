# -*coding: utf-8-*-

import json

from babel.dates import (
    format_datetime,
    format_date
)
from webhelpers.html import tags
from webhelpers.html import HTML

from ...resources.employees import Employees
from ...resources.licences import Licences
from ...resources.bpersons import BPersons
from ...resources.contacts import Contacts
from ...resources.hotelcats import Hotelcats
from ...resources.countries import Countries
from ...resources.regions import Regions
from ...resources.locations import Locations
from ...resources.touroperators import Touroperators
from ...resources.accomodations import Accomodations
from ...resources.roomcats import Roomcats
from ...resources.foodcats import Foodcats
from ...resources.hotels import Hotels
from ...resources.currencies import Currencies
from ...resources.persons import Persons
from ...resources.tours import Tours

from ..utils.common_utils import (
    get_locale_name,
    gen_id,
)
from ..utils.common_utils import translate as _
from ..bl.tasks import PRIORITIES


def yes_no_field(value=None, name='yes_no'):
    choices = [
        (0, 'no'),
        (1, 'yes'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto',editable:false"
    )


def status_field(value=None, name='status'):
    choices = [
        ('', '--None--'),
        (0, 'active'),
        (1, 'archive'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w15',
        data_options="panelHeight:'auto',editable:false"
    )


def structures_combotree_field(
    value=None, name='parent_id', options=None
):
    data_options = """
        url: '/structures/list',
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
        url: '/resources_types/list',
        valueField: 'id',
        textField: 'rt_humanize',
        editable: false,
        onBeforeLoad: function(param){
            param.sort = 'rt_humanize';
            param.rows = 0;
            param.page = 1;
        },
        loadFilter: function(data){
            return data.rows;
        }
    """
    return tags.text(name, value, class_="easyui-combobox text w20",
                     data_options=data_options
                     )


def permisions_yes_no_field(value=None, permision="view", name='permisions'):
    choices = [
        ("", 'no'),
        (permision, 'yes'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto'"
    )


def navigations_combotree_field(
    position_id, value=None, name='parent_id'
):
    data_options = """
        url: '/navigations/list',
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

    return tags.text(name, value, class_="easyui-combotree text w20",
                     data_options=data_options
                     )


def employees_combobox_field(
    request, value=None, name='employee_id', id=None, options=None
):
    permisions = Employees.get_permisions(Employees, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/employees/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/employees/edit',"
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
        url: '/employees/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def positions_combobox_field(
    structure_id, value=None, name='position_id'
):
    data_options = """
        url: '/positions/list',
        valueField: 'id',
        textField: 'position_name',
        editable: false,
        onBeforeLoad: function(param){
            param.sort = 'position_name';
            param.rows = 0;
            param.page = 1;
            param.structure_id = %s
        },
        loadFilter: function(data){
            return data.rows;
        }
    """ % structure_id
    return tags.text(name, value, class_="easyui-combobox text w20",
                     data_options=data_options
                     )


def permisions_scope_type_field(
    value='structure', name='scope_type'
):
    choices = [
        ("all", 'all'),
        ("structure", 'structure'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto',editable:false"
    )


def date_field(value, name, options=None):
    id = gen_id()
    data_options = "editable:false"
    if options:
        data_options += ",%s" % options
    if value:
        value = format_date(value, format="short", locale=get_locale_name())
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
        value = format_date(value, format="short", locale=get_locale_name())
    html = tags.text(
        name, value, class_="easyui-timespinner text w10",
        id=id, **{'data-options': data_options}
    )
    return html


def datetime_field(value, name, options=None):
    id = gen_id()
    data_options = "editable:false,width:150,showSeconds:false"
    if options:
        data_options += ",%s" % options
    if value:
        value = format_datetime(
            value, format="short", locale=get_locale_name()
        )
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
    choices = [
        ('', '--None--'),
        ('female', 'female'),
        ('male', 'male'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false,width:126"
    )


def contact_type_combobox_field(
    value=None, name='contact_type'
):
    choices = [
        ('phone', 'phone'),
        ('email', 'email'),
        ('skype', 'skype'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false"
    )


def licences_combobox_field(
    request, value=None, name='licence_id', id=None, options=None
):
    permisions = Licences.get_permisions(Licences, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/licences/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/licences/edit',"
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
        url: '/licences/list',
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
        toolbar: '#%(tb_id)s',
        onBeforeLoad: function(param){
            var this_selector = '#%(obj_id)s';
            var response_id = $(this_selector).data('response');
            var id = %(id)s;
            console.log(this_selector);
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def bpersons_combobox_field(
    request, value=None, name='bperson_id', id=None, options=None
):
    permisions = BPersons.get_permisions(BPersons, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bpersons/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/bpersons/edit',"
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
        url: '/bpersons/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def contacts_combobox_field(
    request, value=None, name='contact_id', id=None, options=None
):
    permisions = Contacts.get_permisions(Contacts, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/contacts/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/contacts/edit',"
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
        url: '/contacts/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def hotelcats_combobox_field(
    request, value=None, name='hotelcat_id', id=None, options=None
):
    permisions = Hotelcats.get_permisions(Hotelcats, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotelcats/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotelcats/edit',"
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
        url: '/hotelcats/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def countries_combobox_field(
    request, value=None, name='country_id', id=None, options=None
):
    permisions = Countries.get_permisions(Countries, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/countries/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/countries/edit',"
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
        url: '/countries/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def regions_combobox_field(
    request, value=None, name='region_id', id=None, options=None
):
    permisions = Regions.get_permisions(Regions, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/regions/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/regions/edit',"
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
        url: '/regions/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def locations_combobox_field(
    request, value=None, name='location_id', id=None, options=None
):
    permisions = Locations.get_permisions(Locations, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/locations/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/locations/edit',"
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
        url: '/locations/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def touroperators_combobox_field(
    request, value=None, name='touroperator_id', id=None, options=None
):
    permisions = Touroperators.get_permisions(Touroperators, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/touroperators/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/touroperators/edit',"
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
        url: '/touroperators/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def accomodations_combobox_field(
    request, value=None, name='accomodation_id', id=None, options=None
):
    permisions = Accomodations.get_permisions(Accomodations, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/accomodations/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/accomodations/edit',"
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
        url: '/accomodations/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def foodcats_combobox_field(
    request, value=None, name='foodcat_id', id=None, options=None
):
    permisions = Foodcats.get_permisions(Foodcats, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/foodcats/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/foodcats/edit',"
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
        url: '/foodcats/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def roomcats_combobox_field(
    request, value=None, name='roomcat_id', id=None, options=None
):
    permisions = Roomcats.get_permisions(Roomcats, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/roomcats/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/roomcats/edit',"
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
        url: '/roomcats/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def hotels_combobox_field(
    request, value=None, name='hotel_id', id=None, options=None
):
    permisions = Hotels.get_permisions(Hotels, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotels/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/hotels/edit',"
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
        url: '/hotels/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def currencies_combobox_field(
    request, value=None, name='currency_id', id=None, options=None
):
    permisions = Currencies.get_permisions(Currencies, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/currencies/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/currencies/edit',"
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
        url: '/currencies/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def persons_combobox_field(
    request, value=None, name='person_id', id=None, options=None
):
    permisions = Persons.get_permisions(Persons, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/persons/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/persons/edit',"
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
        url: '/persons/list',
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
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def tours_combobox_field(
    request, value=None, name='tour_id', id=None, options=None
):
    permisions = Tours.get_permisions(Tours, request)
    obj_id = id or gen_id()
    toolbar_id = 'tb-%s' % obj_id
    toolbar = []
    if 'add' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/tours/add'"
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
    if 'edit' in permisions:
        kwargs = {
            'data-options':
                "container:'#%s',action:'dialog_open',url:'/tours/edit',"
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
        {'field': 'locations', 'title': _(u"locations"),
            'sortable': True, 'width': 200},
        {'field': 'hotels', 'title': _(u"hotels"),
            'sortable': True, 'width': 200},
        {'field': 'start_dt', 'title': _(u"start"),
            'sortable': True, 'width': 60},
        {'field': 'end_dt', 'title': _(u"end"),
            'sortable': True, 'width': 60},
    ]]

    data_options = """
        url: '/tours/list',
        panelWidth: 700,
        fitColumns: true,
        scrollbarSize: 7,
        border: false,
        delay: 500,
        idField: 'id',
        textField: 'locations',
        mode: 'remote',
        sortName: 'id',
        sortOrder: 'desc',
        columns: %(columns)s,
        pageSize: 50,
        showHeader: true,
        view: bufferview,
        toolbar: '#%(tb_id)s',
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
        'tb_id': toolbar_id
    })
    if options:
        data_options += """,
            %s
        """ % options
    if toolbar:
        toolbar = HTML.tag(
            'div', class_='combogrid-toolbar', id=toolbar_id,
            c=HTML(*toolbar)
        )
    return HTML(
        tags.text(
            name, value,
            id=obj_id,
            class_="easyui-combogrid text w20",
            data_options=data_options,
        ),
        toolbar if toolbar else ''
    )


def passport_type_field(request, value=None, name='passport_type'):
    choices = [
        ('citizen', _(u'citizen')),
        ('foreign', _(u'foreign')),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w15',
        data_options="panelHeight:'auto',editable:false"
    )


def tasks_priority_combobox_field(
    request, value=None, name='priority'
):
    return tags.select(
        name, value, PRIORITIES, class_='easyui-combobox text w10',
        data_options="panelHeight:'auto',editable:false,width:126"
    )
