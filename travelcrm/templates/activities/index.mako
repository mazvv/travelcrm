<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
%>
<div class="easyui-panel"
    data-options="
        height: 300,
        border:false,
        iconCls:'fa fa-bar-chart',
        tools:'#${_t_id}'
    ">
    <div class="dp100 mb05 mt05">
        <span class="fa fa-history ml05"></span>
        <span class="fs110 ml05 b mr05">
            ${_(u'My last activities')} (10)
        </span>
    </div>
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:10,singleSelect:true,
            rownumbers:false,sortName:'modifydt',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,showHeader:false,showFooter:false,
            onBeforeLoad: function(param){
                param['employee_id'] = ${employee_id};
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:false,width:50">${_(u"id")}</th>
            <th data-options="field:'resource_type',sortable:false,width:220">${_(u"resource type")}</th>
            <th data-options="field:'modifydt',sortable:false,width:120">${_(u"updated")}</th>
        </thead>
    </table>
</div>
