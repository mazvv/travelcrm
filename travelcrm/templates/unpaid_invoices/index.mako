<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
%>
<div class="easyui-panel"
    data-options="
        height: 300,
        border:true,
        iconCls:'fa fa-table',
        tools:'#${_t_id}'
    "
    title="${_(u'Unpaid Invoices')}">
    ${context_info(_t_id, request)}
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'active_until',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false
        " width="100%">
        <thead>
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'active_until',sortable:true,width:80">${_(u"active until")}</th>
            <th data-options="field:'customer',sortable:true,width:150">${_(u"customer")}</th>
            <th data-options="field:'payments_percent',sortable:false,width:80,formatter:function(value, row, index){return payment_indicator(row.payments_percent);}">${_(u"payments, %")}</th>            
        </thead>
    </table>
</div>
