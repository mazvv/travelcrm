<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"tour service"), True, "service_id")}
                </div>
                <div class="ml15">
                ${h.fields.services_combobox_field(request, item.service_id if item else None)}
                ${h.common.error_container(name='service_id')}
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
                ${h.tags.title(_(u"person"), True, "person_id")}
            </div>
            <div class="ml15">
                ${h.fields.persons_combobox_field(request, item.person_id if item else None)}
                ${h.common.error_container(name="person_id")}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"price"), True, "price")}
            </div>
            <div class="ml15">
                ${h.tags.text('price', item.price if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                ${h.common.error_container(name='price')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"price currency"), True, "currency_id")}
            </div>
            <div class="ml15">
                ${h.fields.currencies_combobox_field(request, item.currency_id if item else None)}
                ${h.common.error_container(name='currency_id')}
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
