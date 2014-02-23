<div class="easyui-panel _container unselectable"
    data-options="
    	fit:true,
    	border:false,
    	iconCls:'fa fa-table'
    "
    title="${_(u'Countries')}">
    <table class="easyui-datagrid"
    	id="countries-dg"
        data-options="
        	url:'${request.resource_url(_context, 'list')}',border:false,
        	pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#countries-dg-tb'
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'iso_code',sortable:true,width:100">${_(u"iso code")}</th>
            <th data-options="field:'country_name',sortable:true,width:200">${_(u"name")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="countries-dg-tb">
        <div class="actions button-container dl45">
            <a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add')}">
            	<span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
           	</a>
            <div class="button-group">
                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit')}">
                	<span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
                </a>
	            <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete')}">
	            	<span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
	            </a>
	        </div>
        </div>
        <div class="ml45 tr">
            <div class="searchbar">
	            <strong>${h.tags.title(_(u"Search"), False, "search")}</strong>
	            ${h.tags.text("search", None, class_="text w25 searchbox")}
	            <div class="search-tools">
		            <span class="fa fa-filter easyui-tooltip" title="${_(u'advanced')}"></span>
		            <span class="fa fa-search easyui-tooltip" title="${_(u'search')}"></span>
	            </div>
            </div>
        </div>
    </div>
</div>
