<%namespace file="../address/common.mak" import="address_selector"/>
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
        <div class="easyui-tabs h100" data-options="border:false,height:300">
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
                        ${h.tags.title(_(u"subject"), True, "subject")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("subject", item.subject if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='subject')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"start at"), True, "start_dt")}
                    </div>
                    <div class="ml15">
                        ${h.fields.datetime_field(item.start_dt if item else None, 'start_dt')}
                        ${h.common.error_container(name='start_dt')}
                    </div>
                </div>
            </div>
            <div title="${_(u'HTML content')}">
                ${h.tags.textarea('html_content', item.html_content if item else None, class_="rich-text-editor")}
            </div>
            <div title="${_(u'Plain text')}">
                ${h.tags.textarea('plain_content', item.plain_content if item else None, class_="rich-text-editor")}
                <script type="easyui-textbox/javascript">
                    $('.rich-text-editor').jqte({"format":false});
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
