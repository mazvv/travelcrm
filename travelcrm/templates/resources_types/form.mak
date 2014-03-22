<div class="dl40 easyui-dialog"
    title="${title or _(u'Add Company')}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"humanize"), True, "humanize")}
            </div>
            <div class="ml15">
                ${h.tags.text("humanize", item.humanize if item else None, class_="text w20")}
                ${h.common.error_container(name='humanize')}
            </div>
        </div>
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
                ${h.tags.title(_(u"resource"), True, "resource")}
            </div>
            <div class="ml15">
                ${h.tags.text("resource", item.resource_full if item else None, class_="text w20")}
                ${h.common.error_container(name='resource')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                 ${h.tags.title(_(u"description"), False, "description")}
            </div>
            <div class="ml15">
                ${h.tags.textarea("description", item.description if item else None, class_="text w20", rows=4)}
                ${h.common.error_container(name='description')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"status"), True, "status")}
            </div>
            <div class="ml15">
                ${h.fields.status_field(item.resource_obj.status if item else None)}
                ${h.common.error_container(name='status')}
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
