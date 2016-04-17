<%inherit file="travelcrm:templates/auth/_layout.mako"/>
<div class="easyui-dialog dl35" title="${_(u'Forgot password')}"
    data-options="
        closable:false,
        minimizable:false,
        maximizable:false,
        collapsible:false,
        draggable:true,
        resizable:false,
        iconCls:'fa fa-envelope'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field mb05">
            <div class="dl10">
                ${h.tags.title(_(u"email"), True, "email")}
            </div>
            <div class="ml10">
                ${h.tags.text("email", None, class_="easyui-textbox w15")}
                ${h.common.error_container(name='email')}
            </div>
        </div>
        <div class="form-field mb05">
            <i class="fa fa-long-arrow-left"></i>
            ${h.tags.link_to(_(u"Back to autorization"), auth_url)}
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar">
                <i class="fa fa-info-circle fa-lg"></i> ${_(u"Please, enter your email")}
            </div>
            <div class="ml20 tr">
                ${h.tags.submit('send', _(u"Send"), class_="button easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
