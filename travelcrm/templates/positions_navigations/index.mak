<div class="dl60 easyui-dialog _container"
    data-options="
        border:false,
        height:500,
        modal:true,
        iconCls:'fa fa-table'
    "
    title="${_(u'Position Navigations')} | ${company_position.name}">
    <table class="easyui-treegrid" id="positions-navigations-dg"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,iconCls:'fa fa-table',sortName:'position',sortOrder:'asc',
            pageList:[50,100,500],idField:'_id',treeField:'name',
            checkOnSelect:false,selectOnCheck:false,toolbar:'#positions-navigations-dg-tb',
            onBeforeLoad:function(row, param){
                param.companies_positions_id = ${company_position.id};
            }
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',width:60">${_(u"id")}</th>
            <th align="center" data-options="field:'icon_cls',width:20,formatter:function(value,row,index){if(value) return '<i class=\'' + value + '\'></i>';}"></th>
            <th data-options="field:'name',width:300">${_(u"name")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'owner',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"owner")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="positions-navigations-dg-tb">
        <div class="actions button-container">
            <a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add', query={'companies_positions_id': company_position.id})}">
                <span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
            </a>
            <div class="button-group">
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit')}">
                    <span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
                </a>
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'company_structure', 'copy')}">
                    <span class="fa fa-copy"></span> <span>${_(u"Copy")}</span>
                </a>
                <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete')}">
                    <span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
                </a>
            </div>
            <div class="button-group">
                <a href="#" class="button _action _with_row" data-url="${request.resource_url(_context, 'up')}">
                    <span class="fa fa-arrow-up"></span> <span>${_(u"Up")}</span>
                </a>
                <a href="#" class="button _action _with_row" data-url="${request.resource_url(_context, 'down')}">
                    <span class="fa fa-arrow-down"></span> <span>${_(u"Down")}</span>
                </a>
            </div>
        </div>
    </div>

</div>
