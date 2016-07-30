<%def name="header(company_name)">
    <div class="dl30 logo">
        ${h.tags.image(request.static_url('travelcrm:static/css/img/logo.png'), _(u'TravelCRM'))}
        <span class="logo-big">Travel<span class="lipstick">CRM</span></span>
        <span class="ml1">${company_name}</span>
    </div>
    % if hasattr(_context, 'is_logged') and _context.is_logged():
    <div class="dl70">
        <div class="dl30">&nbsp;</div>
        <div class="dl40">
            ${panel('employee_info_panel')}
        </div>
    </div>
    <div class="dr10 tr">
       <div class="logout">
           <a href="#" class="dashed-link _action"
               data-options="action:'dialog_open',url:'/logout'">
               ${_(u'logout')} <span class="fa fa-sign-out"></span>
           </a>
       </div>
    </div>
    % endif
</%def>

<%def name="footer()">
    <div class="main tc">
        Powered by <a href="http://www.travelcrm.org.ua" class="project-link">Travelcrm</a> | ver. ${h.common.get_package_version('travelcrm')}
    </div>
</%def>


<%def name="employee_info()">
    <div class="employee-info dl30">
        <div class="dl5 tr">
            <%
               photo = employee.photo and employee.photo.path or 'no-image.png'
            %>
            ${h.tags.image(
                request.route_url(
                    'thumbs',
                    size='small',
                    path=request.storage.url(photo)
                ),
                employee.name,
                align='center',
                width=30,
                height=30
            )}
        </div>
        <div class="ml5">
            <div class="pl05">
                <div class="b">
                    <a href="#" class="dashed white easyui-tooltip no-text-decoration _action"
                       data-options="action:'dialog_open',url:'/users/profile'"
                       title="${_(u'edit profile')}">
                        ${employee.name}
                    </a>
                </div>
                <div><span class="b">${position.name}</span> ${_(u'in')} ${h.tags.literal(' &rarr; '.join(structure_path))}</div>
            </div>
        </div>
    </div>
    <div class="dl10">
        <div class="employee-quick-menu">
            <a class="fa fa-flask quick-menu-item _action easyui-tooltip"
                title="${_(u'tasks')}" onclick="$('#_tasks_').closest('.easyui-tabs').tabs('select', 0);"
            >
                <div class="indicator tasks-counter">
                </div>
            </a>
            <a class="fa fa-bell-o quick-menu-item _action easyui-tooltip ml1"
                title="${_(u'notifications')}" onclick="$('#_notifications_').closest('.easyui-tabs').tabs('select', 2);"
            >
                <div class="indicator notifications-counter">
                </div>
            </a>
        </div>
    </div>
</%def>
