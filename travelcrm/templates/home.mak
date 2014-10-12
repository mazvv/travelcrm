<%inherit file="travelcrm:templates/_layout.mak"/>
<div title="${_(u"Home")}" 
    data-options="
        closable:false,
        fit:true,
        border:false
    ">
    Home content
</div>
<%block name="js">
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-groupview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-scrollview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-detailview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-bufferview.js'))}
</%block>