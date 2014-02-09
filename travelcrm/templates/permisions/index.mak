<div class="dl60 easyui-dialog _container"
    data-options="
        border:false,
        height:400,
        modal:true,
        iconCls:'fa fa-table'
    "
    title="${_(u'Position Permissions')} | ${position.name}">
    <table class="easyui-datagrid"
    	id="permisions-dg"
        data-options="
        	url:'${request.resource_url(_context, 'list')}',border:false,
        	pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#permisions-dg-tb',
            onBeforeLoad: function(param){
                param.position_id = ${position.id};
            }
        " width="100%">
        <thead>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'rt_humanize',sortable:true,width:300">${_(u"resource type")}</th>
            <th align="center" data-options="field:'permisions',width:20,formatter:function(value,row,index){if(value) return '<i class=\'fa fa-unlock-alt\'></i>';}"></th>
            <th align="center" data-options="field:'scope_type',width:80">${_(u"scope type")}</th>
            <th align="center" data-options="field:'structure_id',width:80,formatter:function(value,row,index){if(value) return '<i class=\'fa fa-circle\'></i>';}">${_(u"structure")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="permisions-dg-tb">
        <div class="actions button-container dl20">
            <a href="#" class="button _dialog_open _with_row" 
                data-url="${request.resource_url(_context, 'edit', query=[('position_id', position.id)])}">
                <span class="fa fa-pencil"></span> <span>${_(u"Edit Permissions")}</span>
            </a>
        </div>
        <div class="ml20 tr">
            <strong>${h.tags.title(_(u"Search"), False, "search")}</strong>
            ${h.tags.text("search", None, class_="text w25")}
        </div>
        <div class="clear"></div>
    </div>
</div>
