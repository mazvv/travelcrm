<div class="dl50 easyui-dialog"
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
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"bank"), True, "bank_id")}
            </div>
            <div class="ml15">
                ${h.fields.banks_combogrid_field(
                    request,
                    'bank_id',
                    item.bank_id if item else None,
                    show_toolbar=(not readonly if readonly else True)
                )}
                ${h.common.error_container(name='bank_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"currency"), True, "currency_id")}
            </div>
            <div class="ml15">
                ${h.fields.currencies_combogrid_field(
                    request,
                    'currency_id',
                    item.currency_id if item else None,
                    show_toolbar=(not readonly if readonly else True)
                )}
                ${h.common.error_container(name='currency_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"beneficiary"), True, "beneficiary")}
            </div>
            <div class="ml15">
                ${h.tags.text("beneficiary", item.beneficiary if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='beneficiary')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"account"), True, "account")}
            </div>
            <div class="ml15">
                ${h.tags.text("account", item.account if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='account')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"swift code"), True, "swift_code")}
            </div>
            <div class="ml15">
                ${h.tags.text("swift_code", item.swift_code if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='swift_code')}
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
