<%namespace file="../notes/common.mako" import="note_selector"/>
<%namespace file="../tasks/common.mako" import="task_selector"/>
<div class="dl70 easyui-dialog"
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
                        ${h.fields.datetime_field('start_dt', item.start_dt if item else None)}
                        ${h.common.error_container(name='start_dt')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"status"), True, "status")}
                    </div>
                    <div class="ml15">
                        ${h.fields.campaigns_statuses_combobox_field(
                            'status',
                            item.status.key if item else None,
                            data_options='readonly:true'
                        )}
                    </div>
                </div>
            </div>
            <div title="${_(u'HTML content')}">
                ${h.tags.textarea(
                    'html_content', 
                    item.html_content if item else None,
                    class_="rich-text-editor",
                    cols=103,
                    rows=18,
                )}
                <script>
                    $('textarea[name=html_content]').ace({lang: 'html'});
                </script>
            </div>
            <div title="${_(u'Plain text')}">
                ${h.tags.textarea(
                    'plain_content',
                    item.plain_content if item else None,
                    class_="rich-text-editor",
                    cols=103,
                    rows=18,
                )}
                <script>
                    $('textarea[name=plain_content]').ace({lang: 'html'});
                </script>
            </div>
            <div title="${_(u'Notes')}">
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
            <div title="${_(u'Tasks')}">
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
