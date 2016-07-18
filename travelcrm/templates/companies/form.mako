<%namespace file="../common/infoblock.mako" import="infoblock"/>
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
        % if item:
           ${infoblock(_(u"If you change company settings you need to reload page"))}
        % endif    
        <div class="form-field mt05">
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
                ${h.tags.title(_(u"base currency"), True, "currency_id")}
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
                ${h.tags.title(_(u"timezone"), True, "timezone")}
            </div>
            <div class="ml15">
                ${h.fields.timezones_field('timezone', item.settings.get('timezone') if item else None, style="width:271px;")}
                ${h.common.error_container(name='timezone')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"locale"), True, "locale")}
            </div>
            <div class="ml15">
                ${h.fields.locales_field('locale', item.settings.get('locale') if item else None)}
                ${h.common.error_container(name='locale')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"contact email"), True, "email")}
            </div>
            <div class="ml15">
                ${h.tags.text("email", item.email if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='email')}
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
