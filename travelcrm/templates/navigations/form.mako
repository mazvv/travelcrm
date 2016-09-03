<%namespace file="../notes/common.mako" import="note_selector"/>
<%namespace file="../tasks/common.mako" import="task_selector"/>
<div class="dl60 easyui-dialog"
    title="${title} | ${position.name}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(
        action or request.url,
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off", 
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        % if item:
            ${h.tags.hidden('position_id', position.id)}
        % endif
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"name"), True, "name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("name", item.name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"parent navigation"), False, "parent_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.navigations_combotree_field('parent_id', position.id, item.parent_id if item else None)}
                        ${h.common.error_container(name='parent_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"url"), False, "url")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("url", item.url if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='url')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"icon css class"), False, "icon_cls")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("icon_cls", item.icon_cls if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='icon_cls')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"action"), False, "action")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("action", item.action if item else 'tab_open', class_="easyui-textbox w20")}
                        ${h.common.error_container(name='action')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"separator before"), False, "separator_before")}
                    </div>
                    <div class="ml15">
                        ${h.fields.yes_no_field('separator_before', int(item.separator_before) if item else None)}
                        ${h.common.error_container(name='separator_before')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Notes')}" data-options="disabled:${h.common.jsonify(not bool(item))}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${note_selector(
                        values=(
                            [note.id for note in item.resource.notes]
                            if item and item.resource else []
                        ),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Tasks')}" data-options="disabled:${h.common.jsonify(not bool(item))}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${task_selector(
                        values=(
                            [task.id for task in item.resource.tasks]
                            if item and item.resource else []
                        ),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button easyui-linkbutton")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger easyui-linkbutton")}
            </div>
        </div>    
    ${h.tags.end_form()}
</div>
