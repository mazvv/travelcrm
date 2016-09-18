<%namespace file="../common/infoblock.mako" import="infoblock"/>
<%namespace file="../tags/common.mako" import="tags_selector"/>
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
        <div class="easyui-tabs h100" data-options="border:false,height:350">
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
                        )}
                        ${h.common.error_container(name='status')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Settings')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"mail template"), True, "mail_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.mails_combogrid_field(
                            request, 
                            'mail_id',
                            item.mail_id if item else None, 
                            show_toolbar=(not readonly if readonly else True),
                        )}
                        ${h.common.error_container(name='mail_id')}
                    </div>
                </div>
                ${infoblock(
                    _(u"Filter settings. Only clients with criteria below will be processed or all clients DB")
                )}
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"category"), False, "person_category_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.persons_categories_combogrid_field(
                            request, 
                            'person_category_id',
                            item.person_category_id if item else None, 
                            show_toolbar=(not readonly if readonly else True),
                        )}
                        ${h.common.error_container(name='person_category_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"tags"), False, "tag_id")}
                    </div>
                    <div class="ml15">
                        ${tags_selector(
                            values=[
                                tag for tag in item.resource.tags
                            ] if item and item.resource else [],
                            can_edit=(not readonly if readonly else True)
                        )}
                    </div>
                </div>
                % if not readonly:
                    ${infoblock(_(u"Tools"))}
                    <div class="form-field">
                        <div class="dl15">
                            ${h.tags.title(_(u"coverage"), False, "coverage")}
                        </div>
                        <div class="ml15">
                            ${h.tags.text(
                                "coverage", None, class_="easyui-textbox w20",
                                data_options='disabled:true'
                            )}
                            ${h.tags.link_to(
                                _(u'Show'), '#',
                                data_url=request.resource_url(_context, 'coverage'),
                                class_="easyui-linkbutton button",
                                data_options="""
                                    onClick: function(){
                                        var a = $(this);
                                        var input = a.closest('form').find('#coverage');
                                        var url = a.data('url');
                                        var data = a.closest('form')
                                            .find('[name=csrf_token], [name=person_category_id], [name=tag_id]')
                                            .serialize();
                                        $.ajax({
                                            url: url,
                                            type: 'post',
                                            data: data,
                                            dataType: 'json',
                                            success: function(json){
                                                input.textbox('setValue', json.response);
                                            }
                                        });
                                    }
                                """
                            )}
                        </div>
                    </div>
                % endif
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
