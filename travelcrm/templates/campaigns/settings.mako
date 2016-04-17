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
                ${h.tags.title(_(u"SMTP host"), True, "host")}
            </div>
            <div class="ml15">
                  ${h.tags.text(
                      'host',
                      rt.settings.get("host") if rt.settings else None,
                      class_='easyui-textbox text w20',
                  )}
                  ${h.common.error_container(name='host')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"SMTP port"), True, "port")}
            </div>
            <div class="ml15">
                  ${h.tags.text(
                      'port',
                      rt.settings.get("port") if rt.settings else 2525,
                      class_='easyui-textbox text w20',
                  )}
                  ${h.common.error_container(name='port')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"username"), True, "username")}
            </div>
            <div class="ml15">
                  ${h.tags.text(
                      'username',
                      rt.settings.get("username") if rt.settings else None,
                      class_='easyui-textbox text w20',
                  )}
                  ${h.common.error_container(name='username')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"password"), True, "password")}
            </div>
            <div class="ml15">
                  ${h.tags.password(
                      'password',
                      rt.settings.get("password") if rt.settings else None,
                      class_='easyui-textbox text w20',
                  )}
                  ${h.common.error_container(name='password')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"default sender"), True, "default_sender")}
            </div>
            <div class="ml15">
                  ${h.tags.text(
                      'default_sender',
                      rt.settings.get("default_sender") if rt.settings else None,
                      class_='easyui-textbox text w20',
                  )}
                  ${h.common.error_container(name='default_sender')}
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
