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
                ${h.tags.title(_(u"name"), True, "name")}
            </div>
            <div class="ml15">
                ${h.tags.text("name", item.name if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"account item"), True, "account_item_id")}
            </div>
            <div class="ml15">
                ${h.fields.accounts_items_combobox_field(request, item.account_item_id if item else None)}
                ${h.common.error_container(name='account_item_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"invoice text"), False, "display_text")}
            </div>
            <div class="ml15">
                ${h.tags.text('display_text', item.display_text if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='display_text')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"explicit"), False, "explicit")}
            </div>
            <div class="ml15">
                ${h.fields.yes_no_field(item.explicit if item else 1, name="explicit")}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"description"), False, "descr")}
            </div>
            <div class="ml15">
                ${h.tags.text('descr', item.descr if item else None, class_="easyui-textbox w20", data_options="multiline:true,height:80")}
                ${h.common.error_container(name='descr')}
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
