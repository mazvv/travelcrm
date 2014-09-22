<%
    _id = h.common.gen_id()
    _form_id = "form-%s" % _id
%>
<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off", id=_form_id)}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"payment date"), True, "date")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.date if item else None, 'date')}
                ${h.common.error_container(name='date')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"touroperator"), True, "touroperator_id")}
            </div>
            <div class="ml15">
                ${h.fields.touroperators_combobox_field(request, item.touroperator_id if item else None)}
                ${h.common.error_container(name='touroperator_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"payment account"), True, "account_id")}
            </div>
            <div class="ml15">
                ${h.fields.accounts_combobox_field(
                    request, item.account_id if item else None, 
                    show_toolbar=False, structure_id=structure_id,
                    options="onSelect: function(index, data){$('#%s .currency').textbox('setValue', data.currency)}" % _form_id
                )}
                ${h.common.error_container(name='account_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"sum"), True, "sum")}
            </div>
            <div class="ml15">
                ${h.tags.text('sum', item.sum if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                ${h.common.error_container(name='sum')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"sum currency"), False, "currency")}
            </div>
            <div class="ml15">
                ${h.tags.text('currency', item.invoice.account.currency.iso_code if item else None, class_="easyui-textbox w20 currency", disabled=True)}
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
