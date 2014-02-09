<div class="easyui-panel _container unselectable"
    data-options="
        fit:true,
        border:false,
        iconCls:'fa fa-table'
    "
    title="${_(u'Company Positions')}">
    <table class="easyui-datagrid"
    	id="positions-dg"
        data-options="
        	url:'${request.resource_url(_context, 'list')}',border:false,
        	pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#positions-dg-tb'
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'position_name',sortable:true,width:300">${_(u"name")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="positions-dg-tb">
        <div class="actions button-container dl40">
            <a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add')}">
            	<span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
           	</a>
            <div class="button-group">
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit')}">
                	<span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
                </a>
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'copy')}">
                    <span class="fa fa-copy"></span> <span>${_(u"Copy")}</span>
                </a>
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'permisions')}">
                    <span class="fa fa-unlock"></span> <span>${_(u"Permissions")}</span>
                </a>
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'navigations')}">
                    <span class="fa fa-gear"></span> <span>${_(u"Menu")}</span>
                </a>
            </div>
            <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete')}">
            	<span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
            </a>
        </div>
        <div class="ml40 tr">
            <strong>${h.tags.title(_(u"Search"), False, "search")}</strong>
            ${h.tags.text("search", None, class_="text w25")}
        </div>
        <div class="clear"></div>
    </div>
</div>
