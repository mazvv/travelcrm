${h.tags.Doctype().html5()}
<html>
    <head>        
        <meta http-equiv="Content-Type" content="easyui-textbox/html; charset=utf-8" />
        <title>${_(u"TravelCRM - login")}</title>
        <link rel="icon" type="image/ico" href="${request.static_url('travelcrm:static/css/img/favicon.ico')}"/>
        ${h.tags.stylesheet_link(
            request.static_url('travelcrm:static/css/jeasyui/gray/easyui.css'), 
            request.static_url('travelcrm:static/css/main.css')
        )}
        <%block name="css"></%block>
        ${h.tags.javascript_link(
            request.static_url('travelcrm:static/js/jquery-1.10.2.min.js'), 
            request.static_url('travelcrm:static/js/jquery-migrate-1.2.1.min.js'),
            request.static_url('travelcrm:static/js/jeasyui/jquery.easyui.min.js'),
            request.static_url('travelcrm:static/js/jeasyui/locale/easyui-lang-%s.js' % h.common.get_locale_name()),
            request.static_url('travelcrm:static/js/main.js'),
        )}
        <%block name="js"></%block>
    </head>
    <body id="_page_" class="easyui-layout">
        <div id="_head_" data-options="region:'north', border:false">
            <div id="_top_">
                <div class="main">
                    ${panel('header_panel')}
                </div>
            </div>
        </div>
        <div id="_footer_" data-options="region:'south', border:false">
            ${panel('footer_panel')}
        </div>
        <div id="_main_" data-options="region:'center', border:false">
            ${self.body()}
        </div>
    </body>
</html>