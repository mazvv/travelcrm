<%namespace file="../notes/common.mak" import="notes_selector"/>
<%namespace file="../tasks/common.mak" import="tasks_selector"/>
<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax %s" % ('readonly' if readonly else ''), autocomplete="off")}
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"name"), True, "name")}
            </div>
            <div class="ml15">
                ${h.tags.text("name", item.name if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"base currency"), True, "currency_id")}
            </div>
            <div class="ml15">
                ${h.fields.currencies_combobox_field(
                    request, item.currency_id if item else None,
                    show_toolbar=(not readonly if readonly else True)
                )}
                ${h.common.error_container(name='currency_id')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"timezone"), True, "timezone")}
            </div>
            <div class="ml15">
                ${h.fields.timezones_field(item.settings.get('timezone') if item else None, style="width:271px;")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"locale"), True, "locale")}
            </div>
            <div class="ml15">
                ${h.tags.text("locale", item.settings.get('locale') if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='locale')}
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
