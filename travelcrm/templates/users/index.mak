<%namespace file="../common/search.mak" import="searchbar"/>
<%namespace file="../common/buttons.mak" import="action_button"/>
<%
	h_id = h.common.gen_id()
%>
<div class="easyui-panel _container unselectable"
    data-options="
    	fit:true,
    	border:false,
    	iconCls:'fa fa-table'
    "
    title="${_(u'Users')}">
    <table class="easyui-datagrid"
    	id="dg-${h_id}"
        data-options="
        	url:'${request.resource_url(_context, 'list')}',border:false,
        	pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#dg-tb-${h_id}',
            onBeforeLoad: function(param){
                var dg = $(this);
                var searchbar = $(this).closest('._container').find('.searchbar');
                console.log(searchbar.find('input'));
                $.each(searchbar.find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'employee_name',sortable:true,width:200">${_(u"employee")}</th>
            <th data-options="field:'username',sortable:true,width:200">${_(u"username")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="dg-tb-${h_id}">
        <div class="actions button-container dl45">
            ${action_button(
            	_context, request.resource_url(_context, 'add'), 'add', 
            	'primary _dialog_open', 'fa fa-plus', _(u'Add New')
            )}
           	<div class="button-group">
           		${action_button(
           			_context, request.resource_url(_context, 'edit'), 'edit', 
           			'_dialog_open _with_row', 'fa fa-pencil', _(u'Edit')
           		)}
           		${action_button(
           			_context, request.resource_url(_context, 'delete'), 'delete', 
           			'danger _dialog_open _with_rows', 'fa fa-times', _(u'Delete')
           		)}
	        </div>
        </div>
        <div class="ml45 tr">
            ${searchbar()}
        </div>
    </div>
</div>
