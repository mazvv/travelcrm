# -*coding: utf-8-*-

from datetime import (
    date,
    datetime
)
from babel.dates import (
    format_datetime,
    format_date
)
from webhelpers.html import tags

from ..utils.common_utils import get_locale_name


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
    value=None, name='employee_id'
):
    data_options = """
        url: '/employees/list',
        valueField: 'id',
        textField: 'name',
        editable: false,
        onBeforeLoad: function(param){
            param.sort = 'name';
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
