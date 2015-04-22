<%namespace file="../common/infoblock.mak" import="infoblock"/>
<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(
        request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off",
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"date from"), True, "date_from")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.date_from if item else None, "date_from")}
                ${h.common.error_container(name='date_from')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"service"), True, "service_id")}
            </div>
            <div class="ml15">
                ${h.fields.services_combobox_field(
                    request, item.service_id if item else None,
                    show_toolbar=(not readonly if readonly else True)
                )}
                ${h.common.error_container(name='service_id')}
            </div>
        </div>
        ${infoblock(_(u"Set amount of commission in % and sum. You can use zero."))}
        <div class="form-field mt1">
            <div class="dl15">
                ${h.tags.title(_(u"percentage"), True, "percentage")}
            </div>
            <div class="ml15">
                ${h.tags.text('percentage', item.percentage if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,max:100,precision:2")}
                ${h.common.error_container(name='percentage')}
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
                ${h.fields.currencies_combobox_field(
                    request, item.currency_id if item else None,
                    show_toolbar=(not readonly if readonly else True)
                )}
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
