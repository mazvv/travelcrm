<%inherit file="travelcrm:templates/auth/_layout.mako"/>
<div class="easyui-dialog dl30" title="${_(u'Autorization')}"
    data-options="
        closable:false,
        minimizable:false,
        maximizable:false,
        collapsible:false,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-user'
    ">
    ${h.tags.form(auth_url, class_="_ajax", autocomplete="off")}
        <div class="form-field tc">
            % if h.common.is_public_domain(request):
                <span class="b">
                    ${_(u'Username:')} <span class="lipstick">admin</span>, 
                    ${_(u'Password:')} <span class="lipstick">adminadmin</span>
                </span>
            % endif
        </div>
        <div class="form-field">
            <div class="dl10">
                ${h.tags.title(_(u"username"), False, "username")}
            </div>
            <div class="ml10 tr">
                ${h.tags.text("username", None, class_="easyui-textbox w15")}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl10">
                ${h.tags.title(_(u"password"), False, "password")}
            </div>
            <div class="ml10 tr">
                ${h.tags.password("password", None, class_="easyui-textbox w15")}
            </div>
        </div>
        <div class="form-field mb1">
            % if h.common.can_create_company(request):
                <span class="mr1">
                    <i class="fa fa-hand-o-right"></i>
                    ${h.tags.link_to(_(u"Create company"), add_url)}
                </span>
            % endif
            <i class="fa fa-unlock-alt"></i>
            ${h.tags.link_to(_(u"Forgot password?"), forgot_url)}
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar">
                <i class="fa fa-info-circle fa-lg"></i> ${_(u"Please, enter username and password")}
            </div>
            <div class="ml20 tr">
                ${h.tags.submit('login', _(u"Login"), class_="button easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
