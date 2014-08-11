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
                ${h.tags.title(_(u"appointment date"), True, "date")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.date if item else None, "date")}
                ${h.common.error_container(name='date')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"employee"), True, "employee_id")}
            </div>
            <div class="ml15">
               ${h.fields.employees_combobox_field(request=request, value=item.employee_id if item else None)}
               ${h.common.error_container(name='employee_id')}
            </div>
        </div>
        <div class="form-field mb05 mt05">
            <div class="dl15">
                ${h.tags.title(_(u'position'), True, "position_id")}
            </div>
            <div class="ml15">
                ${h.fields.positions_combogrid_field(request, item.position_id if item else None, name='position_id')}
                ${h.common.error_container(name='position_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"salary"), True, "salary")}
            </div>
            <div class="ml15">
                ${h.tags.text('salary', item.salary if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                ${h.common.error_container(name='salary')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"currency"), True, "currency_id")}
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
