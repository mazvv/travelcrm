<%namespace file="../common/infoblock.mako" import="infoblock"/>
<div class="dl45 easyui-dialog"
    title="${_(u'Edit Permissions')}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(
        action or request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off", 
        hidden_fields=[('resource_type_id', resource_type.id), ('csrf_token', request.session.get_csrf_token())]
    )}
        % for permision in allowed_permisions:
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(permision[1], False, "permisions")}
            </div>
            <div class="ml15">
                ${h.fields.permisions_switch_field(
                    'permisions', 
                    permision[0] if item and permision[0] in item.permisions else None,
                    permision=permision[0]
                )}
            </div>
        </div>
        % endfor
        % if not allowed_scopes:
            ${infoblock(_(u'Scopes is not allowed for this Resource Type'))}
        % endif
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"scope type"), False, "scope_type")}
            </div>
            <div class="ml15">
                ${h.fields.permisions_scope_type_field(
                    'scope_type',
                    item.scope_type if item else 'all', 
                    data_options=('disabled:true' if not allowed_scopes else '')
                )}
                ${h.common.error_container(name='scope_type')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"scope structure"), False, "structure_id")}
            </div>
            <div class="ml15">
                ${h.fields.structures_combotree_field(
                    'structure_id',
                    item.structure_id if item else None, 
                    data_options=('disabled:true' if not allowed_scopes else '')
                )}
                ${h.common.error_container(name='structure_id')}
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