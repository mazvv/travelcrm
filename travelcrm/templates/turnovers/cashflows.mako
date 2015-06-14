<%
    _id = h.common.gen_id()
%>
<div class="dl75 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        resizable:false,
        height:400,
        iconCls:'fa fa-lightbulb-o'
    ">
	<table class="easyui-datagrid"
	    id="${_id}"
	    data-options="
	        url:'${request.resource_url(_context, 'cashflows')}',border:false,
	        pagination:true,fit:true,pageSize:50,singleSelect:true,
	        rownumbers:true,sortName:'id',
	        pageList:[50,100,500],idField:'_id',checkOnSelect:false,
	        showFooter:true,
	        selectOnCheck:false,
	        onBeforeLoad: function(param){
	            var dg = $(this);
	            var params = $.parseJSON('${h.common.jsonify(request.params.mixed())}');
	            $.each(params, function(name, val){
	            	if(name == 'id'){
	            		param[params['report_by'] + '_' + name] = val;
	            	} else {
	            		param[name] = val;
	            	}
	            });
	        }
	    " width="100%">
	    <thead>
	        <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
	        <th data-options="field:'date',sortable:true,width:80">${_(u"date")}</th>
	        <th data-options="field:'from',sortable:true,width:200">${_(u"from")}</th>
	        <th data-options="field:'to',sortable:true,width:200">${_(u"to")}</th>
	        <th data-options="field:'account_item',sortable:true,width:150">${_(u"account item")}</th>
			<th data-options="field:'sum',sortable:true,width:100">${_(u"sum")}</th>
            <th data-options="field:'currency',sortable:true,width:80">${_(u"currency")}</th>
	    </thead>
	</table>
</div>
