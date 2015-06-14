<%namespace file="../common/infoblock.mako" import="infoblock"/>
<%namespace file="../notes/common.mako" import="note_selector"/>
<%namespace file="../tasks/common.mako" import="task_selector"/>
<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(
        request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off",
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="easyui-tabs h100" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"employee"), True, "employee_id")}
                    </div>
                    <div class="ml15">
                       ${h.fields.employees_combogrid_field(
                          request=request,
                          'employee_id',
                          value=item.employee_id if item else None,
                          show_toolbar=(not readonly if readonly else True)
                       )}
                       ${h.common.error_container(name='employee_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"username"), False, "username")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("username", item.username if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='username')}
                    </div>
                </div>
                % if not readonly:
                    % if item:
                        ${infoblock(_(u"If you do not change password, take this fields empty"))}
                    % endif
                    <div class="form-field">
                        <div class="dl15">
                            ${h.tags.title(_(u"password"), False if item else True, "password")}
                        </div>
                        <div class="ml15">
                            ${h.tags.password("password", None, class_="easyui-textbox w20")}
                            ${h.common.error_container(name='password')}
                        </div>
                    </div>
                    <div class="form-field mb05">
                        <div class="dl15">
                            ${h.tags.title(_(u"confirm password"), False if item else True, "password_confirm")}
                        </div>
                        <div class="ml15">
                            ${h.tags.password("password_confirm", None, class_="easyui-textbox w20")}
                            ${h.common.error_container(name='password_confirm')}
                        </div>
                    </div>
                % endif
            </div>
            <div title="${_(u'Notes')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${note_selector(
                        values=([note.id for note in item.resource.notes] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Tasks')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${task_selector(
                        values=([task.id for task in item.resource.tasks] if item else []),
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
                ${h.tags.submit('save', _(u"Save"), class_="button")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
