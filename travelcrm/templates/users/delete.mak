<div class="dl40 easyui-dialog"
    title="${_(u'Delete Employees')}"
    data-options="
        modal:true,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.resource_url(_context, 'delete'), class_="_ajax", autocomplete="off", hidden_fields=[('id', id) for id in request.params.get('id').split(',')])}
        <div class="p1">
            <div class="mb1">
                <i class="fa fa-info-circle fa-lg"></i> 
                ${_(u"Do you realy want to delete checked items?")}
            </div>
            <div>
                <span class="lipstick">${_(u"ATTENTION:")}</span>
                ${_(u"it's highly not recommend to delete users. it may have destructive aftermath!")}
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('delete', _(u"Delete"), class_="button")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
