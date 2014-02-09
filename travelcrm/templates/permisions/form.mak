<div class="dl40 easyui-dialog"
    title="${_(u'Edit Permissions')}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off", hidden_fields=[('position_id', position.id), ('resource_type_id', resource_type.id)])}
        % for permision in allowed_permisions:
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(permision[1], False, "permisions")}
            </div>
            <div class="ml15">
                ${h.fields.permisions_yes_no_field(permision[0] if item and permision[0] in item.permisions else None, permision=permision[0])}
            </div>
        </div>
        % endfor
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"scope type"), False, "scope_type")}
            </div>
            <div class="ml15">
                ${h.fields.permisions_scope_type(item.scope_type if item else 'structure', 'scope_type')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"scope structure"), False, "structure_id")}
            </div>
            <div class="ml15">
                ${h.fields.structures_combotree_field(item.structure_id if item else None, name="structure_id")}
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