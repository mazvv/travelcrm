<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _t_id = "t-%s" % _id
    _s_id = "s-%s" % _id
%>
<div class="dl70 easyui-dialog"
    title="${title}"
    data-options="
        border:false,
        height:400,
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-table',
        tools:'#${_t_id}'
    ">
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
                    '/calculations/details?id=' + row.id, 
                    function(){
                        $('#${_id}').datagrid('fixDetailRowHeight', index);
                        $('#${_id}').datagrid('fixRowHeight', index);
                    }
                );
            },
            detailFormatter: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                return '<div id=' + row_id + '></div>';
            },
            onBeforeLoad: function(param){
                param.id = ${id};
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'service',sortable:true,width:120">${_(u"service")}</th>
            <th data-options="field:'supplier',sortable:true,width:200">${_(u"supplier")}</th>
            <th data-options="field:'price',sortable:true,width:80">${_(u"price")}</th>
            <th data-options="field:'currency',sortable:true,width:60">${_(u"currency")}</th>
            <th data-options="field:'subscriber',sortable:false,width:20,styler:datagrid_resource_cell_styler,formatter:subscriber_cell_formatter"><span class="fa fa-thumb-tack"></span></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl50">
            <div class="button-group minor-group">
                % if _context.has_permision('autoload'):
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'autoload', query={'id': id})}'">
                    <span class="fa fa-plus"></span>${_(u'Autoload')}
                </a>
                % endif
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
                % endif
                % if _context.has_permision('delete'):
                <a href="#" class="button danger easyui-linkbutton _action" 
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'delete')}'">
                    <span class="fa fa-times"></span>${_(u'Delete')}
                </a>
                % endif
            </div>
        </div>
    </div>
</div>
