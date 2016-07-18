<div class="dl45 easyui-dialog"
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
        <div class="form-field mt05">
            <div class="dl15">
                ${h.tags.title(_(u"contact type"), True, "contact_type")}
            </div>
            <div class="ml15">
                ${h.fields.contact_type_combobox_field('contact_type', item.contact_type.key if item else None)}
                ${h.common.error_container(name='contact_type')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"contact"), True, "contact")}
            </div>
            <div class="ml15">
                ${h.tags.text("contact", item.contact if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='contact')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"status"), True, "status")}
            </div>
            <div class="ml15">
                ${h.fields.contracts_statuses_combobox_field(
                    'status',
                    item.status.key if item else None
                )}
                ${h.common.error_container(name='status')}
            </div>
        </div>
        <div class="form-field mb05">
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
        
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button easyui-linkbutton")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
