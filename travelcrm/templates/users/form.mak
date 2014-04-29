<%namespace file="../common/infoblock.mak" import="infoblock"/>
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
                ${h.tags.title(_(u"employee"), True, "employee_id")}
            </div>
            <div class="ml15">
               ${h.fields.employees_combobox_field(request=request, value=item.employee_id if item else None)}
               ${h.common.error_container(name='employee_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"username"), False, "username")}
            </div>
            <div class="ml15">
                ${h.tags.text("username", item.username if item else None, class_="text w20")}
                ${h.common.error_container(name='username')}
            </div>
        </div>
        % if item:
            ${infoblock(_(u"If you do not change password, take this fields empty"))}
        % endif
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"password"), False if item else True, "password")}
            </div>
            <div class="ml15">
                ${h.tags.password("password", None, class_="text w20")}
                ${h.common.error_container(name='password')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"confirm password"), False if item else True, "password_confirm")}
            </div>
            <div class="ml15">
                ${h.tags.password("password_confirm", None, class_="text w20")}
                ${h.common.error_container(name='password_confirm')}
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
