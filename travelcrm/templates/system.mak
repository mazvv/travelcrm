<%def name="system_info_dialog(title, message)">
    <div class="dl30 easyui-dialog" title="${title}"
        data-options="modal:true,draggable:false,resizable:false,iconCls:'fa fa-info-circle'">
        <div class="p1">
            <div class="tc fs110">${message}</div>
        </div>
    </div>
</%def>


<%def name="system_navigation(navigation)">
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
    <a href="#" class="button" style="position: absolute;top:0;right:0;" onclick="$(this).closest('.easyui-panel').panel('refresh');">
        <span class="fa fa-refresh"> ${_(u'Reload')}
    </a>
</%def>
