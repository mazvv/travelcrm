<div class="dl50 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            <div title="${_(u'SMTP')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"SMTP host"), True, "host_smtp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'host_smtp',
                              rt.settings.get("host_smtp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='host_smtp')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"SMTP port"), True, "port_smtp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'port_smtp',
                              rt.settings.get("port_smtp") if rt.settings else 2525,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='port_smtp')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"username"), True, "username_smtp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'username_smtp',
                              rt.settings.get("username_smtp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='username_smtp')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"password"), True, "password_smtp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.password(
                              'password_smtp',
                              rt.settings.get("password_smtp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='password_smtp')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"default sender"), True, "default_sender_smtp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'default_sender_smtp',
                              rt.settings.get("default_sender_smtp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='default_sender_smtp')}
                    </div>
                </div>
            </div>
            <div title="${_(u'SMPP')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"SMPP host"), True, "host_smpp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'host_smpp',
                              rt.settings.get("host_smpp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='host_smpp')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"SMPP port"), True, "port_smpp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'port_smpp',
                              rt.settings.get("port_smpp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='port_smpp')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"username"), True, "username_smpp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.text(
                              'username_smpp',
                              rt.settings.get("username_smpp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='username_smpp')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"password"), True, "password_smpp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.password(
                              'password_smpp',
                              rt.settings.get("password_smpp") if rt.settings else None,
                              class_='easyui-textbox text w20',
                          )}
                          ${h.common.error_container(name='password_smpp')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"system type"), True, "system_type_smpp")}
                    </div>
                    <div class="ml15">
                          ${h.tags.select(
                              'system_type_smpp',
                              rt.settings.get("system_type_smpp") if rt.settings else None,
                              [ 
                                ('transmitter', 'transmitter'), 
                                ('receiver', 'receiver'),
                                ('transceiver', 'transceiver')
                              ],
                              class_='easyui-combobox text w20',
                          )}
                          ${h.common.error_container(name='system_type_smpp')}
                    </div>
                </div>
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
