<%namespace file="../note/common.mak" import="note_selector"/>
<%namespace file="../task/common.mak" import="task_selector"/>
<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax %s" % ('readonly' if readonly else ''), autocomplete="off")}
        <div class="easyui-tabs h100" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"humanize"), True, "humanize")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            "humanize", 
                            item.humanize if item else None, 
                            class_="easyui-textbox w20", 
                        )}
                        ${h.common.error_container(name='humanize')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"name"), True, "name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            "name", 
                            item.name if item else None, 
                            class_="easyui-textbox w20",
                        )}
                        ${h.common.error_container(name='name')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"resource"), True, "resource")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            "resource", 
                            item.resource_full if item else None, 
                            class_="easyui-textbox w20", 
                        )}
                        ${h.common.error_container(name='resource')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"customizable"), False, "customizable")}
                    </div>
                    <div class="ml15">
                        ${h.fields.yes_no_field(
                            int(item.customizable) if item else None, 
                            "customizable"
                        )}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                         ${h.tags.title(_(u"description"), False, "description")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            "description", 
                            item.description if item else None, 
                            class_="easyui-textbox w20", 
                            data_options="multiline:true,height:80",
                        )}
                        ${h.common.error_container(name='description')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"status"), True, "status")}
                    </div>
                    <div class="ml15">
                        ${h.fields.resources_types_statuses_combobox_field(
                            item.status.key if item else None 
                        )}
                    </div>
                </div>
            </div>
            <div title="${_(u'Notes')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${note_selector(
                        values=([note.id for note in item.resource_obj.notes] if item else []),
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
                        values=([task.id for task in item.resource_obj.tasks] if item else []),
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
