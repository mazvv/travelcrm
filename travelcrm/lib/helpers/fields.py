# -*coding: utf-8-*-

from webhelpers.html import tags


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
        (1, 'disabled'),
        (2, 'draft'),
        (3, 'error'),
    ]
    return tags.select(
        name, value, choices, class_='easyui-combobox text w15',
        data_options="panelHeight:'auto'"
    )


def company_structures_combotree_field(
    companies_id, value=None, name='parent_id'
):
    data_options = """
        url: '/companies_structures/list',
        onBeforeLoad: function(node, param){
            param.companies_id = %s;
            param.sort = 'struct_name';
    """ % companies_id
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


def resources_types_combobox_field(
    value=None, name='resources_types_id'
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


def company_position_navigations_combotree_field(
    companies_positions_id, value=None, name='parent_id'
):
    data_options = """
        url: '/positions_navigations/list',
        onBeforeLoad: function(node, param){
            param.companies_positions_id = %s;
            param.sort = 'name';
    """ % companies_positions_id
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
