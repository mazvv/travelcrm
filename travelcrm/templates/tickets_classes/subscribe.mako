<div class="dl40 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        resizable:false,
        iconCls:'fa fa-state-o'
    ">
    ${h.tags.form(request.resource_url(_context, 'subscribe'), class_="_ajax", autocomplete="off", hidden_fields=[('id', id) for id in request.params.get('id').split(',')])}
        <div class="p1">
            <div class="tc">
                <i class="fa fa-info-circle fa-lg"></i> 
                ${_(u"Do you realy want to change subscribe of checked items?")}
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl25 status-bar"></div>
            <div class="ml25 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button easyui-linkbutton")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
