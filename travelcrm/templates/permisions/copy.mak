<div class="dl40 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off", hidden_fields=[('position_id', position.id)])}
        <div class="form-field mb05 mt05">
            <div class="dl15">
                ${h.tags.title(_(u'from position'), True, "from_position_id")}
            </div>
            <div class="ml15">
                ${h.fields.positions_combogrid_field(request, 'from_position_id', show_toolbar=False)}
                ${h.common.error_container(name='from_position_id')}
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