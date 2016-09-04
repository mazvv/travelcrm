<%namespace file="../contacts/common.mako" import="contact_selector"/>
<%namespace file="../passports/common.mako" import="passports_selector"/>
<%namespace file="../addresses/common.mako" import="address_selector"/>
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
        <div class="easyui-tabs h100" data-options="border:false,height:400">
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
                        ${h.tags.title(_(u"gender"), False, "gender")}
                    </div>
                    <div class="ml15">
                        ${h.fields.gender_combobox_field('gender', item.gender.key if item else None)}
                        ${h.common.error_container(name='gender')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"birthday"), False, "birthday")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field('birthday', item.birthday if item else None)}
                        ${h.common.error_container(name='birthday')}
                    </div>
                </div>
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
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"description"), False, "descr")}
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
            <div title="${_(u'Passports')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${passports_selector(
                        values=([passport.id for passport in item.passports] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Addresses')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${address_selector(
                        values=([address.id for address in item.addresses] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Subscriptions')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"email subscription"), False, "email_subscription")}
                    </div>
                    <div class="ml15">
                        ${h.fields.switch_field(
                            'email_subscription',
                            item.email_subscription if item else None, 
                        )}
                        ${h.common.error_container(name='email_subscription')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"sms subscription"), False, "sms_subscription")}
                    </div>
                    <div class="ml15">
                        ${h.fields.switch_field(
                            'sms_subscription',
                            item.sms_subscription if item else None, 
                        )}
                        ${h.common.error_container(name='sms_subscription')}
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
