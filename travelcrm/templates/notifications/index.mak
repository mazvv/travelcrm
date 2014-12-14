<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _t_id = "t-%s" % _id
%>
<div class="dl55 easyui-dialog"
    title="${_(u'Notifications')}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        height: 400,
        iconCls:'fa fa-pencil-square-o'
    ">
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'created',sortOrder:'asc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/notifications/details?id=' + row.id, 
                    function(){
                        $('#${_id}').datagrid('fixDetailRowHeight', index);
                        $('#${_id}').datagrid('fixRowHeight', index);
                    }
                );
            },
            detailFormatter: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                return '<div id=' + row_id + '></div>';
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'title',sortable:true,width:400">${_(u"title")}</th>
            <th data-options="field:'created',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"created")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl45">
            % if _context.has_permision('delete'):
            <a href="#" class="button danger _action" 
                data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'delete')}'">
                <span class="fa fa-times"></span>${_(u'Delete')}
            </a>
            % endif
        </div>
    </div>
</div>