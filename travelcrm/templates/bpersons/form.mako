<%namespace file="../contacts/common.mako" import="contact_selector"/>
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
        action or request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off",
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"first name"), True, "first_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("first_name", item.first_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='first_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"second name"), False, "second_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("second_name", item.second_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='second_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"last name"), False, "last_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("last_name", item.last_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='last_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"position name"), True, "position_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("position_name", item.position_name if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='position_name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"status"), True, "status")}
                    </div>
                    <div class="ml15">
                        ${h.fields.bpersons_statuses_combobox_field(
                            'status',
                            item.status.key if item else None
                        )}
                        ${h.common.error_container(name='status')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"description"), False, "descr")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            "descr", 
                            item.descr if item else None, 
                            class_="easyui-textbox w20", 
                            data_options="multiline:true,height:80",
                        )}
                        ${h.common.error_container(name='descr')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Contacts')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${contact_selector(
                        values=([contact.id for contact in item.contacts] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
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
