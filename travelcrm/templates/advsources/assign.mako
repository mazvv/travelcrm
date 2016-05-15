<%namespace file="../common/infoblock.mako" import="infoblock"/>
<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.resource_url(_context, 'assign'), class_="_ajax", autocomplete="off", hidden_fields=[('id', id) for id in request.params.get('id').split(',')])}
        ${infoblock(_(u"All checked items will assign to another maintainer"))}    
        <div class="form-field mb05 mt05">
            <div class="dl15">
                ${h.tags.title(_(u"new maintainer"), True, "maintainer_id")}
            </div>
            <div class="ml15">
                ${h.fields.employees_combogrid_field(
                    request,
                    'maintainer_id',
                    show_toolbar=False
                )}
                ${h.common.error_container(name='maintainer_id')}
            </div>
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('delete', _(u"Assign"), class_="button easyui-linkbutton")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger easyui-linkbutton")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
