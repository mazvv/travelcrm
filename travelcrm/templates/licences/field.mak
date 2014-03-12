<div class="easyui-panel _container unselectable"
    data-options="
    	fit:true,
    	border:false,
    	iconCls:'fa fa-table'
    ">
    <table class="easyui-datagrid"
    	id="dg-${h_id}"
        data-options="
        	url:'${request.url}',border:false,
        	pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#dg-tb-${h_id}',
            onBeforeLoad: function(param){
                var licences = $(this).closest('._container').find('input[name=licence_id]');
                var ids = [-1];
                if(licences.length){
                    $.each(licences, function(i, field){ids.push($(field).val());});
                }
                param.id = ids.join();
            }
        " width="100%">
        <thead>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'licence_num',sortable:true,width:150">${_(u"licence num")}</th>
            <th data-options="field:'date_from',sortable:true,width:100">${_(u"date from")}</th>
            <th data-options="field:'date_to',sortable:true,width:100">${_(u"date to")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="dg-tb-${h_id}">
        ${h.fields.licences_combobox_field(name='licence_id', with_grid=True)}
    </div>
</div>
