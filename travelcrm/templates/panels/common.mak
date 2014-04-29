<%def name="header()">
	<div class="dl30 logo">
	    ${h.tags.image(request.static_url('travelcrm:static/css/img/logo.png'), _(u'TravelCRM'))} <span class="logo-big">Travel<span class="lipstick">CRM</span></span>
	</div>
    % if hasattr(_context, 'is_logged') and _context.is_logged():
    <div class="dl70">
        <div class="dl40">&nbsp;</div>
        <div class="dl30">
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


<%def name="navigation(navigation)">
    <%def name="navigation_item(item, key)">
        % if navigation.get(item.id) is None:
            <a href="#" class="${'easyui-linkbutton' if not item.parent_id else 'easyui-menubutton'} _action"
                id="${'_navigation_item_%d' % item.id}" iconCls="${item.icon_cls}"
                data-options="plain:true,action:'tab_open',url:'${item.url}',title:'${item.name}'">
                % if key:
                    ${item.name}
                % else:
                    <span>${item.name}</span>
                % endif
            </a>            
        % else:
            <a href="#" class="easyui-menubutton _action" 
                id="${'_navigation_item_%d' % item.id}" iconCls="${item.icon_cls}"
                data-options="menu:'${'#_navigation_submenu_%d' % item.id}',action:'tab_open',url:'${item.url}',title:'${item.name}'">
                % if key:
                    ${item.name}
                % else:
                    <span>${item.name}</span>
                % endif
            </a>
        % endif
    </%def>
    <%def name="navigation_items(key)">
        % for item in navigation[key]:
            % if key:
                <div>
                    ${navigation_item(item, key)}
                </div>
            % else:
                ${navigation_item(item, key)}
            % endif
            % if navigation.get(item.id):
                <div id="${'_navigation_submenu_%d' % item.id}">
                    ${navigation_items(item.id)}
                </div>
            % endif
        % endfor
    </%def>
    ${navigation_items(None)}
</%def>


<%def name="employee_info()">
    <div class="employee-info">
	    <div class="dl5 tr">
	        <%
	           photo = employee.photo or 'no-image.png'
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
		        <div class="b">${employee.name}</div>
		        <div><span class="b">${position.name}</span> ${_(u'in')} ${' &rarr; '.join(structure_path)}</div>
	        </div>
	    </div>
    </div>
</%def>
