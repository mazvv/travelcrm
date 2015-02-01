<%def name="system_info_dialog(title, message)">
    <div class="dl30 easyui-dialog" title="${title}"
        data-options="modal:true,draggable:false,resizable:false,iconCls:'fa fa-info-circle'">
        <div class="p1">
            <div class="tc fs110">${message}</div>
        </div>
    </div>
</%def>


<%def name="system_navigation(navigation)">
    <%def name="navigation_items(key)">
    	% if navigation.get(key):
	        % for item in navigation.get(key):
	        	% if item.separator_before:
	        		<div class="menu-sep"></div>
	        	% endif
	        	<div>
	       		% if navigation.get(item.id):
	       			<span>
						<a href="#" class="_action"
						    iconCls="${item.icon_cls}"
						    data-options="action:'${item.action or 'tab_open'}',url:'${item.url}',title:'${item.name}'">
						    ${item.name}
						</a>
	       			</span>
	       			<div>
	       				${navigation_items(item.id)}
	       			</div>
	       		% else:
					<a href="#" class="_action"
					    iconCls="${item.icon_cls}"
					    data-options="action:'${item.action or 'tab_open'}',url:'${item.url}',title:'${item.name}'">
					    ${item.name}
					</a>
	       		% endif
	       		</div>
	        % endfor
        % endif
    </%def>
    % for item in navigation.get(None):
    	% if navigation.get(item.id):
			<a href="#" class="easyui-menubutton _action"
			    id="${'_navigation_item_%d' % item.id}" iconCls="${item.icon_cls}"
			    data-options="menu:'${'#_navigation_submenu_%d' % item.id}',action:'${item.action or 'tab_open'}',url:'${item.url}',title:'${item.name}'">
			    ${item.name}
			</a>
        % else:
			<a href="#" class="easyui-linkbutton _action"
	            id="${'_navigation_item_%d' % item.id}" iconCls="${item.icon_cls}"
	            data-options="plain:true,action:'${item.action or 'tab_open'}',url:'${item.url}',title:'${item.name}'">
	            ${item.name}
	        </a>		
        % endif
    % endfor
    % for item in navigation.get(None):
    	<div id="_navigation_submenu_${item.id}">
			${navigation_items(item.id)}
		</div>
    % endfor
    <a href="#" class="button" style="position: absolute;top:0;right:0;" onclick="$(this).closest('.easyui-panel').panel('refresh');">
        <span class="fa fa-refresh"> ${_(u'Reload')}
    </a>
</%def>


<%def name="system_context_info_dialog(title)">
    <div class="dl40 easyui-dialog" title="${title}"
        data-options="modal:true,draggable:false,resizable:false,iconCls:'fa fa-info-circle',height:300">
        <table width="100%" 
        	class="easyui-propertygrid"
        	data-options="border:false,scrollbarSize:0,url:'${request.url}',showGroup: true">
        </table>
    </div>
</%def>


<%def name="system_portal()">
    <div id="_portal_" class="easyui-portal" data-options="fit:true,border:false">
        <div class="dp50 p05 pr02"></div>
        <div class="dp50 p05 pl02"></div>
    </div>
</%def>
