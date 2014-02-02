<div class="easyui-panel _container unselectable"
    data-options="
    	fit:true,
    	border:false,
    	iconCls:'fa fa-table'
    "
    title="${_(u'Employees Appointments')}">
    <table class="easyui-datagrid"
    	id="employees-appointments-dg"
        data-options="
        	url:'${request.resource_url(_context, 'list')}',border:false,
        	pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#employees-appointments-dg-tb'
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'employees',width:300">${_(u"employees")}</th>
            <th data-options="field:'appointment_date',sortable:true,width:120">${_(u"date")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'owner',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"owner")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="employees-appointments-dg-tb">
        <div class="actions button-container dl50">
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
            </div>
            <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete')}">
            	<span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
            </a>
        </div>
        <div class="ml50 tr">
            <strong>${h.tags.title(_(u"Search"), False, "search")}</strong>
            ${h.tags.text("search", None, class_="text w25")}
        </div>
    </div>
</div>
