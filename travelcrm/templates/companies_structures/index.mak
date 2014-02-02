<div class="dl70 easyui-dialog _container"
    data-options="
        border:false,
        height:500,
        modal:true,
        iconCls:'fa fa-table'
    "
    title="${_(u'Company Structures')} | ${company.name}">
    <table class="easyui-treegrid" id="companies-structures-dg"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,iconCls:'fa fa-table',sortName:'struct_name',sortOrder:'asc',
            pageList:[50,100,500],idField:'_id',treeField:'struct_name',
            checkOnSelect:false,selectOnCheck:false,toolbar:'#companies-structures-dg-tb',
            onBeforeLoad:function(row, param){
                param.companies_id = ${company.id};
            }
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',width:60">${_(u"id")}</th>
            <th data-options="field:'struct_name',width:300">${_(u"name")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'owner',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"owner")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="companies-structures-dg-tb">
        <div class="actions button-container">
            <a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add', query={'companies_id': company.id})}">
                <span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
            </a>
            <div class="button-group">
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit')}">
                    <span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
                </a>
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'copy')}">
                    <span class="fa fa-copy"></span> <span>${_(u"Copy")}</span>
                </a>
                <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete')}">
                    <span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
                </a>
            </div>
        </div>
    </div>

</div>
