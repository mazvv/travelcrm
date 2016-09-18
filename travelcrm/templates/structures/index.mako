<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _t_id = "t-%s" % _id
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
    <table class="easyui-treegrid" 
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'structure_name',sortOrder:'asc',
            pageList:[50,100,500],idField:'_id',treeField:'structure_name',
            checkOnSelect:false,selectOnCheck:false,toolbar:'#${_tb_id}'
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',width:60">${_(u"id")}</th>
            <th data-options="field:'structure_name',width:300">${_(u"name")}</th>
            <th data-options="field:'subscriber',sortable:false,width:20,styler:datagrid_resource_cell_styler,formatter:subscriber_cell_formatter"><span class="fa fa-thumb-tack"></span></th>
            <th data-options="field:'modifydt',width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
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
        </div>
    </div>
</div>
