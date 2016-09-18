<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
    _tb_id = "tb-%s" % _id
%>
<div class="dl60 easyui-dialog _container"
    data-options="
        border:false,
        height:500,
        modal:true,
        iconCls:'fa fa-table',
        tools:'#${_t_id}'
    "
    title="${title} | ${position.name}">
    ${context_info(_t_id, request)}
    <table class="easyui-treegrid" 
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'sort_order',sortOrder:'asc',
            pageList:[50,100,500],idField:'_id',treeField:'name',
            checkOnSelect:false,selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(node, param){
                param.position_id = ${position.id};
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',width:60">${_(u"id")}</th>
            <th align="center" data-options="field:'icon_cls',width:20,formatter:function(value,row,index){if(value) return '<i class=\'' + value + '\'></i>';}"></th>
            <th data-options="field:'name',width:300">${_(u"name")}</th>
            <th data-options="field:'modifydt',width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            % if _context.has_permision('add'):
            <a href="#" class="button primary easyui-linkbutton _action" 
                data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'add', query={'position_id': position.id})}'">
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
                    data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'copy', query={'position_id': position.id})}'">
                    <span class="fa fa-copy"></span>${_(u'Copy From ...')}
                </a>
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'container_action',property:'with_row',url:'${request.resource_url(_context, 'up')}'">
                    <span class="fa fa-arrow-up"></span>${_(u'Up')}
                </a>
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'container_action',property:'with_row',url:'${request.resource_url(_context, 'down')}'">
                    <span class="fa fa-arrow-down"></span>${_(u'Down')}
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
