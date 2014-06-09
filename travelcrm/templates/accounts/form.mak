<%namespace file="../common/grid_selectors.mak" import="addresses_selector"/>
<div class="dl50 easyui-dialog"
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
                ${h.tags.text("name", item.name if item else None, class_="text w20")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"account type"), True, "account_type")}
            </div>
            <div class="ml15">
                ${h.fields.accounts_types_combobox_field(item.account_type if item else None)}
                ${h.common.error_container(name='account_type')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"currency"), True, "currency_id")}
            </div>
            <div class="ml15">
                ${h.fields.currencies_combobox_field(request, item.currency_id if item else None)}
                ${h.common.error_container(name='currency_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                 ${h.tags.title(_(u"display text"), True, "display_text")}
            </div>
            <div class="ml15">
                ${h.tags.text("display_text", item.display_text if item else None, class_="text w20")}
                ${h.common.error_container(name='display_text')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                 ${h.tags.title(_(u"description"), False, "descr")}
            </div>
            <div class="ml15">
                ${h.tags.textarea("descr", item.descr if item else None, class_="text w20", rows=4)}
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
