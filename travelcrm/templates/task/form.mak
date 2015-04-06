<%namespace file="../note/common.mak" import="note_selector"/>
<div class="dl55 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax %s" % ('readonly' if readonly else ''), autocomplete="off")}
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
                        ${h.tags.title(_(u"performer"), True, "employee_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.employees_combobox_field(
                        	request, 
                        	item.employee_id if item else h.common.get_auth_employee(request).id, 
                        	show_toolbar=False
                        )}
                        ${h.common.error_container(name='employee_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"reminder"), True, "reminder")}
                    </div>
                    <div class="ml15">
                        ${h.fields.datetime_field(item.reminder if item else None, 'reminder')}
                        ${h.common.error_container(name='reminder')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"deadline"), True, "deadline")}
                    </div>
                    <div class="ml15">
                        ${h.fields.datetime_field(item.deadline if item else None, 'deadline')}
                        ${h.common.error_container(name='deadline')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"status"), True, "status")}
                    </div>
                    <div class="ml15">
                        ${h.fields.tasks_statuses_combobox_field(
                            item.status.key if item else None
                        )}
                    </div>
                </div>
            </div>
            <div title="${_(u'Description')}">
                ${h.tags.textarea('descr', item.descr if item else None, id="task-rich-text-editor")}
                <script type="easyui-textbox/javascript">
                    $('#task-rich-text-editor').jqte({"format":false});
                </script>
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
