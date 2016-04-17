<%inherit file="travelcrm:templates/auth/_layout.mako"/>
<%namespace file="../common/infoblock.mako" import="infoblock"/>
<div class="dl45 easyui-dialog"
    title="${_(u'Create company')}"
    data-options="
        modal:true,
        draggable:false,
        closable: false,
        resizable:false,
        iconCls:'fa fa-plus'
    ">
    ${h.tags.form(
        request.url, 
        class_="_ajax", 
        autocomplete="off",
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="form-field mt05">
            <div class="dl15">
                ${h.tags.title(_(u"email"), True, "email")}
            </div>
            <div class="ml15">
                ${h.tags.text("email", None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='email')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"name"), True, "name")}
            </div>
            <div class="ml15">
                ${h.tags.text("name", None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"timezone"), True, "timezone")}
            </div>
            <div class="ml15">
                ${h.fields.timezones_field('timezone', style="width:271px;")}
                ${h.common.error_container(name='timezone')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"locale"), True, "locale")}
            </div>
            <div class="ml15">
                ${h.fields.locales_field('locale')}
                ${h.common.error_container(name='locale')}
            </div>
        </div>
        <div class="form-field mb05">
            <i class="fa fa-long-arrow-left"></i>
            ${h.tags.link_to(_(u"Back to autorization"), auth_url)}
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar">
                <i class="fa fa-info-circle fa-lg"></i> ${_(u"Please, feel all fields")}
            </div>
            <div class="ml20 tr">
                ${h.tags.submit('create', _(u"Create"), class_="button easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
