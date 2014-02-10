<%def name="header()">
	<div class="dl20 logo">
	    <span class="logo-big">Travel<span class="lipstick">CRM</span></span>
	</div>
    % if hasattr(_context, 'is_logged') and _context.is_logged():
	<div class="dr10 tr">
	    <div class="logout">
	        <a href="/logout" class="dashed-link _dialog_open" data-url="/logout">${_(u"logout")}</a>
	        <span class="fa fa-sign-out"></span>
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
            <a href="#" class="${'easyui-linkbutton' if not item.parent_id else 'easyui-menubutton'} _tab_open"
                id="${'_navigation_item_%d' % item.id}" iconCls="${item.icon_cls}"
                data-url="${item.url}" data-index="${item.url}" 
                data-title="${item.name}" data-options="plain:true">
                % if key:
                    ${item.name}
                % else:
                    <span>${item.name}</span>
                % endif
            </a>            
        % else:
            <a href="#" class="easyui-menubutton _tab_open" 
                id="${'_navigation_item_%d' % item.id}" iconCls="${item.icon_cls}"
                data-options="menu:'${'#_navigation_submenu_%d' % item.id}'"
                data-url="${item.url}" data-index="${item.url}" data-title="${item.name}">
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
