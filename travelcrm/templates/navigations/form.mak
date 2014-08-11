<div class="dl40 easyui-dialog"
    title="${title} | ${position.name}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off", hidden_fields=[('position_id', position.id),])}
        <div class="form-field">
            <div class="dl15">
                 ${h.tags.title(_(u"name"), True, "name")}
            </div>
            <div class="ml15">
                ${h.tags.text("name", item.name if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='name')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"parent navigation"), False, "parent_id")}
            </div>
            <div class="ml15">
                ${h.fields.navigations_combotree_field(position.id, item.parent_id if item else None)}
                ${h.common.error_container(name='parent_id')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                 ${h.tags.title(_(u"url"), True, "url")}
            </div>
            <div class="ml15">
                ${h.tags.text("url", item.url if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='url')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                 ${h.tags.title(_(u"icon css class"), False, "icon_cls")}
            </div>
            <div class="ml15">
                ${h.tags.text("icon_cls", item.icon_cls if item else None, class_="easyui-textbox w20")}
                ${h.common.error_container(name='icon_cls')}
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
