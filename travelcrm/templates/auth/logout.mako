<div class="dl30 easyui-dialog"
    title="${_(u'Logout Confirmation')}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-sign-out'
    ">
    ${h.tags.form('/logout', autocomplete="off")}
        <div class="p1 tc">
            <i class="fa fa-info-circle fa-lg"></i> <span>${_(u"Do you really want to logout?")}</span>
        </div>
        <div class="form-buttons">
            <div class="dl10 status-bar"></div>
            <div class="ml10 tr button-group">
                ${h.tags.submit('logout', _(u"Logout"), class_="button easyui-linkbutton")}
                ${h.common.reset(
                    'cancel', _(u"Cancel"), 
                    class_="button danger easyui-linkbutton", 
                    onclick="$(this).closest('.easyui-dialog').dialog('destroy');delete_container();"
                )}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
