<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _s_id = "s-%s" % _id    
%>
<div class="dl70 easyui-dialog"
    title="${_(u'Calculations')}"
    data-options="
        border:false,
        height:400,
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-table'
    ">
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
                param.resource_id = ${resource_id};
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'service',sortable:true,width:120">${_(u"service")}</th>
            <th data-options="field:'touroperator',sortable:true,width:120">${_(u"touroperator")}</th>
            <th data-options="field:'price',sortable:true,width:100,formatter:function(value, row, index){return row.currency + ' ' + value;}">${_(u"price")}</th>
            <th data-options="field:'base_price',sortable:true,width:100,formatter:function(value, row, index){return row.base_currency + ' ' + value;}">${_(u"base price")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl50">
            <div class="button-group minor-group">
                % if _context.has_permision('autoload'):
                <a href="#" class="button _action" 
                    data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'autoload', query={'resource_id': resource_id})}'">
                    <span class="fa fa-plus"></span>${_(u'Autoload')}
                </a>
                % endif
                % if _context.has_permision('view'):
                <a href="#" class="button _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'view')}'">
                    <span class="fa fa-circle-o"></span>${_(u'View')}
                </a>
                % endif
                % if _context.has_permision('edit'):
                <a href="#" class="button _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit')}'">
                    <span class="fa fa-pencil"></span>${_(u'Edit')}
                </a>
                % endif
            </div>
        </div>
    </div>
</div>
