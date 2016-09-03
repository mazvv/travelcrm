<!DOCTYPE html>
<html>
    <head>        
        <meta http-equiv="Content-Type" content="easyui-textbox/html; charset=utf-8" />
        <title>${_(u"TravelCRM")}</title>
        <link rel="icon" type="image/ico" href="${request.static_url('travelcrm:static/css/img/favicon.ico')}"/>
        ${h.tags.stylesheet_link(
            request.static_url('travelcrm:static/css/jeasyui/gray/easyui.css'),
            request.static_url('travelcrm:static/css/jeasyui/icon.css'),
            request.static_url('travelcrm:static/css/main.css')
        )}
        <%block name="css"></%block>
        ${h.tags.javascript_link(
            request.static_url('travelcrm:static/js/jquery-1.11.1.min.js'), 
            request.static_url('travelcrm:static/js/jeasyui/jquery.easyui.min.js'),
            request.static_url('travelcrm:static/js/jeasyui/jquery.easyui.patch.js'),
            request.static_url('travelcrm:static/js/jeasyui/locale/easyui-lang-%s.js' % h.common.get_locale_name()),
            request.static_url('travelcrm:static/js/main.js')
        )}
        <%block name="js"></%block>
    </head>
    <body id="_page_">
        <div id="_head_">
            <div id="_top_">
                <div class="main">
                   ${panel('header_panel')}
                </div>
            </div>
            <div id="_navigation_">
                <div class="main">
                    <div class="easyui-panel"
                        style="background-color: transparent;"
                        data-options="
                            href:'/system_navigation',
                            border:false,
                            loadingMessage: '',
                    ">
                    </div>
                </div>
            </div>
        </div>
        <div id="_content_" class="main">
            <div class="easyui-layout" data-options="fit:true,minHeight:650">
                <div id="_tools_" class="dp30" title="${_(u'Tools panel')}" iconCls="fa fa-plug" data-options="region:'east',border:false,split:true,collapsible:true">
                    <div class="easyui-tabs" data-options="fit:true,border:false">
                        <div id="_tasks_" title="${_(u'Tasks')}" data-options="fit:true,border:false,href:'/tasks'">
                        </div>
                        <div id="_notes_" title="${_(u'Notes')}" data-options="fit:true,border:false,href:'/notes'">
                        </div>
                        <div id="_notifications_" title="${_(u'Notifications')}" data-options="fit:true,border:false,href:'/notifications'">
                        </div>
                    </div>
                </div>
                <div id="_main_" data-options="region:'center',border:false">
                    <div id="_tabs_" class="easyui-tabs" data-options="fit:true,border:false">
                        ${self.body()}
                    </div>
                </div>
            </div>
            <div id="_dialog_"></div>
            <div id="_progress_" class="easyui-dialog"
                data-options="title:'${_(u'In Progress')}',modal:true,closed:true,closable:false">
                <div class="dl30 tc mt1 mb1">
                    <span class="fa fa-spinner fa-spin"></span> ${_(u'Please, wait ...')}
                </div>
            </div>
        </div>
        <div id="_footer_">
            <div class="main">
                ${panel('footer_panel')}
            </div>
        </div>
    </body>
</html>
