<%namespace file="../common/context_info.mak" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
%>
<div class="easyui-panel"
    data-options="
        height: 300,
        border: true,
        iconCls:'fa fa-area-chart',
        tools:'#${_t_id}'
    "
    title="${_(u'Sales Dynamics')}">
    ${context_info(_t_id, request)}
    <div class="easyui-panel" data-options="
        fit: true,
        border: false,
        href: '${request.resource_url(_context, 'list')}',
        method: 'post'
    ">
    </div>
</div>