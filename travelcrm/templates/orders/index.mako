<%namespace file="../common/context_info.mako" import="context_info"/>
<%namespace file="../common/search.mako" import="searchbar"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _t_id = "t-%s" % _id
    _s_id = "s-%s" % _id
    _m_id = "m-%s" % _id
%>
<div class="easyui-panel unselectable"
    data-options="
        fit:true,
        border:false,
        iconCls:'fa fa-table',
        tools:'#${_t_id}'
    "
    title="${title}">
    ${context_info(_t_id, request)}
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/orders/details?id=' + row.id, 
                    function(){
                        $('#${_id}').datagrid('fixDetailRowHeight', index);
                        $('#${_id}').datagrid('fixRowHeight', index);
                        $.parser.parse('#' + row_id);
                    }
                );
            },
            detailFormatter: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                return '<div id=' + row_id + '></div>';
            },          
            onBeforeLoad: function(param){
                $.each($('#${_s_id}, #${_tb_id} .searchbar').find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'deal_date',sortable:true,width:80">${_(u"deal date")}</th>
            <th data-options="field:'customer',sortable:true,width:200">${_(u"customer")}</th>
            <th data-options="field:'advsource',sortable:true,width:180">${_(u"advertise")}</th>
            <th data-options="field:'status',sortable:false,width:60,formatter:function(value, row){return status_formatter(value);}">${_(u"status")}</th>
            <th data-options="field:'subscriber',sortable:false,width:20,styler:datagrid_resource_cell_styler,formatter:subscriber_cell_formatter"><span class="fa fa-thumb-tack"></span></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl50">
            % if _context.has_permision('add'):
            <a href="#" class="button primary easyui-linkbutton _action" 
                data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'add')}'">
                <span class="fa fa-plus"></span>${_(u'Add New')}
            </a>
            % endif
            <div class="button-group">
                % if _context.has_permision('view'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'view')}'">
                    <span class="fa fa-circle-o"></span>${_(u'View')}
                </a>
                % endif
                % if _context.has_permision('edit'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit')}'">
                    <span class="fa fa-pencil"></span>${_(u'Edit')}
                </a>
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'copy')}'">
                    <span class="fa fa-copy"></span>${_(u'Copy')}
                </a>
                % endif
                % if _context.has_permision('assign'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'assign')}'">
                    <span class="fa fa-user-secret"></span>${_(u'Assign')}
                </a>
                % endif
                % if _context.has_permision('view'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'subscribe')}'">
                    <span class="fa fa-thumb-tack"></span>${_(u'Subscribe')}
                </a>
                % endif
                % if _context.has_permision('delete'):
                <a href="#" class="button danger easyui-linkbutton _action" 
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'delete')}'">
                    <span class="fa fa-times"></span>${_(u'Delete')}
                </a>
                % endif
            </div>

            % if _context.has_any_permision(('invoice', 'calculation')):
            <a href="#" class="button easyui-menubutton" 
                data-options="menu:'#${_m_id}',plain:false">
                ${_(u'More')}
            </a>
            <div id="${_m_id}" style="width:150px;">
                % if _context.has_permision('view'):
                <div>
                    <a href="#" class="_action"
                        data-options="container:'#${_id}',action:'blank_open',property:'with_row',url:'${request.resource_url(_context, 'print')}'">
                        ${_(u'Print')}
                    </a>
                </div>
                % endif
                % if _context.has_permision('invoice'):
                <div>
                    <a href="#" class="_action"
                        data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'invoice')}'">
                        ${_(u'Invoice')}
                    </a>
                </div>
                % endif
                % if _context.has_permision('calculation'):
                <div>
                    <a href="#" class="_action"
                        data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'calculation')}'">
                        ${_(u'Calculation')}
                    </a>
                </div>
                % endif
            </div>
            % endif

        </div>
        <div class="ml50 tr">
            <div class="search">
                ${searchbar(_id, _s_id, prompt=_(u'Enter customer name'))}
                <div class="advanced-search tl hidden" id = "${_s_id}">
                    <div>
                        ${h.tags.title(_(u"person"))}
                    </div>
                    <div>
                        ${h.fields.persons_combogrid_field(
                            request, 'person_id', show_toolbar=False
                        )}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"service"))}
                    </div>
                    <div>
                        ${h.fields.services_combogrid_field(
                            request, 'service_id', show_toolbar=False
                        )}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"price range"))}
                    </div>
                    <div>
                        ${h.tags.text('price_from', None, class_="easyui-textbox w10 easyui-numberbox", data_options="min:0,precision:0")}
                        <span class="p1">-</span>
                        ${h.tags.text('price_to', None, class_="easyui-textbox w10 easyui-numberbox", data_options="min:0,precision:0")}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"sale dates"))}
                    </div>
                    <div>
                        ${h.fields.date_field('sale_from')}
                        <span class="p1">-</span>
                        ${h.fields.date_field('sale_to')}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"updated"))}
                    </div>
                    <div>
                        ${h.fields.date_field('updated_from')}
                        <span class="p1">-</span>
                        ${h.fields.date_field('updated_to')}
                    </div>
                    <div class="mt05">
                        ${h.tags.title(_(u"maintainer"))}
                    </div>
                    <div>
                        ${h.fields.employees_combogrid_field(request, 'maintainer_id', show_toolbar=False)}
                    </div>
                    <div class="mt1">
                        <div class="button-group minor-group">
                            <a href="#" class="button easyui-linkbutton _advanced_search_submit">${_(u"Find")}</a>
                            <a href="#" class="button easyui-linkbutton" onclick="$(this).closest('.advanced-search').hide();">${_(u"Close")}</a>
                            <a href="#" class="button danger easyui-linkbutton _advanced_search_clear">${_(u"Clear")}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
