<%inherit file="travelcrm:templates/_layout.mak"/>
<div title="${_(u"Home")}"
    data-options="
        closable:false,
        fit:true,
        border:false,
        href:'/system_portal',
        onLoad: function(){
            $('#_portal_').portal();
        }
    "
    >
</div>
<%block name="js">
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/moment.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-groupview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-scrollview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-detailview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-bufferview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/jquery.portal.js'))}
</%block>