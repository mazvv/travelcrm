# -*coding: utf-8-*-

import json

from datetime import (
    date,
)
from babel.dates import (
    format_datetime,
    format_date
)
from webhelpers.html import tags
from webhelpers.html import HTML

from ...resources.employees import Employees
from ...models.employee import Employee
from ..utils.common_utils import (
    get_locale_name,
    get_translate,
    gen_id,
)


def yes_no_field(value=None, name='yes_no'):
    choices = [
        (0, 'no'),
        (1, 'yes'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w5',
        data_options="panelHeight:'auto'"
    )


def status_field(value=None, name='status'):
    choices = [
        (0, 'active'),
        (1, 'archive'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w15',
        data_options="panelHeight:'auto'"
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
    request, value=None, name='employee_id', options=None
):
    _ = request.translate
    permisions = Employees.get_permisions(Employees, request)
    toolbar_id = 'cg-tb-%s' % gen_id()
    toolbar = []
    if 'add' in permisions:
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='_dialog_open fa fa-plus easyui-tooltip',
                title=_(u'add new'), **{'data-url': '/employees/add'}
            )
        )
    if 'edit' in permisions:
        toolbar.append(
            HTML.tag(
                'a', href='#',
                class_='_dialog_open _with_row fa fa-pencil easyui-tooltip',
                title=_(u'edit selected'), **{'data-url': '/employees/edit'}
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
        showFooter: true,
        view: bufferview,
        toolbar: '#%(tb_id)s',
        onBeforeLoad: function(param){
            if(%(id)s && typeof(param.q) == 'undefined'){
                param.id = %(id)s;
            }
            if(!param.page){
                param.page = 1;
                param.rows = 50;
            }
        }
    """ % ({
        'columns': json.dumps(fields),
        'id': json.dumps(value),
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
    return HTML.tag(
        'div', class_='_container',
        c=HTML(
            tags.text(
                name, value,
                class_="easyui-combogrid text w20",
                data_options=data_options,
            ),
            toolbar if toolbar else ''
        )
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
        data_options="panelHeight:'auto'"
    )


def date_field(value, name, options=None):
    if not value:
        value = date.today()
    data_options = "editable:false"
    if options:
        data_options += ",%s" % options
    value = format_date(value, format="short", locale=get_locale_name())
    return tags.text(name, value, class_="easyui-datebox text w10",
        data_options=data_options
    )


def datetime_field(value, name, options=None):
    if not value:
        value = date.now()
    data_options = "editable:false"
    if options:
        data_options += ",%s" % options
    value = format_datetime(value, format="short", locale=get_locale_name())
    return tags.text(name, value, class_="easyui-datetimebox text w10",
        data_options=data_options
    )


def countries_combobox_field(
    value=None, name='country_id'
):
    data_options = """
        url: '/countries/list',
        valueField: 'id',
        textField: 'country_name',
        editable: false,
        onBeforeLoad: function(param){
            param.sort = 'country_name';
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
        data_options="panelHeight:'auto',editable:false"
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
    value=None, name='licence_id', with_grid=False, options=None
):
    _ = get_translate()
    data_options = """
        url: '/licences/field',
        valueField: 'id',
        textField: 'licence_num',
        editable: true,
        mode: 'remote',
        onBeforeLoad: function(param){
            if($(this).val()){
                param.id = $(this).val();
            }
            param.sort = 'licence_num';
            param.rows = 0;
            param.page = 1;
        },
        loadFilter: function(data){
            return data.rows;
        },
        onLoadSuccess: function(){
            if($(this).val()){
                $(this).combobox('setValue', $(this).val());
            }
        }
    """
    if options:
        data_options += """,
            %s
        """ % options
    field = tags.text(
        name if not with_grid else '_%s' % name, value,
        class_="easyui-combobox text w20",
        data_options=data_options,
        **{'data-name': name}
    )
    html_actions = []
    if with_grid:
        html_actions = [
            HTML.tag(
                "div",
                class_=(
                    "fa fa-arrow-circle-down field-action "
                    "easyui-tooltip _accumulator"
                ),
                title=_(u"add to grid")
            ),
        ]
    html_actions.extend([
        HTML.tag(
            "div",
            class_=(
                "fa fa-times-circle field-action "
                "easyui-tooltip _clear"
            ),
            title=_(u"clear field")
        ),
        HTML.tag(
            "div",
            class_=(
                "fa fa-plus-circle field-action "
                "_dialog_open easyui-tooltip"
            ),
            title=_(u"add new"),
            **{'data-url': "/licences/add"}
        )
    ])
    html_actions_container = HTML.tag(
        "span", class_="field-actions",
        c=HTML(*html_actions)
    )
    return HTML.tag(
        "div",
        class_="_container",
        c=HTML(field, html_actions_container)
    )
