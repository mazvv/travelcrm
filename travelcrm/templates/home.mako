<%inherit file="travelcrm:templates/_layout.mako"/>
<div title="${_(u"Home")}"
    data-options="
        closable:false,
        fit:true,
        border:false,
        href:'/system_portal',
        onLoad: function(){
            $('#_portal_').portal();
            var portlets = ${h.common.jsonify(portlets)};
            $.each(portlets, function(i, portlet){
                $.get(portlet.url, function(data){
                    var p = $(data).appendTo('body');
                    $.parser.parse(p);
                    p.panel();
                    $('#_portal_').portal('add', {
                        panel: p,
                        columnIndex: portlet.column_index,
                    });
                });
            });
        },
        tools:[{
            iconCls:'icon-mini-refresh',
            handler:function(){
                var tab = $('#_tabs_').tabs('getTab', 0);
                tab.panel('refresh');
            }
        }]
    "
    >
</div>
<%block name="js">
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/date-format.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-groupview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-scrollview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-detailview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/datagrid-bufferview.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/jeasyui/jquery.portal.js'))}
    ${h.tags.javascript_link(request.static_url('travelcrm:static/js/Chart.js'))}
</%block>