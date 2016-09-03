<%namespace file="../notes/common.mako" import="note_selector"/>
<%namespace file="../uploads/common.mako" import="uploads_selector"/>
<div class="dl55 easyui-dialog"
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
                        ${h.tags.title(_(u"title"), True, "title")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("title", item.title if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='title')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"maintainer"), True, "maintainer_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.employees_combogrid_field(
                        	request,
                        	'maintainer_id',
                        	value=(
                                item.resource.maintainer_id
                                if item and item.resource else 
                                h.common.get_auth_employee(request).id
                            ), 
                        	show_toolbar=False
                        )}
                        ${h.common.error_container(name='maintainer_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"deadline"), True, "deadline")}
                    </div>
                    <div class="ml15">
                        ${h.fields.datetime_field('deadline', item.deadline if item else None)}
                        ${h.common.error_container(name='deadline')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"reminder, min"), True, "reminder")}
                    </div>
                    <div class="ml15">
                        ${h.fields.tasks_reminders_combobox_field('reminder', item.reminder if item else None)}
                        ${h.common.error_container(name='reminder')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"status"), True, "status")}
                    </div>
                    <div class="ml15">
                        ${h.fields.tasks_statuses_combobox_field(
                            'status',
                            item.status.key if item else None
                        )}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"description"), True, "descr")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            'descr', 
                            item.descr if item else None, 
                            class_="easyui-textbox w20", 
                            data_options="multiline:true,height:80"
                        )}
                        ${h.common.error_container(name='descr')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Uploads')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${uploads_selector(
                        values=([upload.id for upload in item.uploads] if item else []),
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
