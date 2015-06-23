<div class="dl50 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field mb05">
            <div class="dl15">
                ${h.tags.title(_(u"vat method"), True, "vat_method")}
            </div>
            <div class="ml15">
                  ${h.tags.text(
                      'vat_method', 
                      rt.settings.get("vat_type") if rt.settings else None,
                      class_="easyui-numberspinner text w10",
                      data_options="min:0,max:1,editable:false"
                  )}
                  ${h.common.error_container(name='vat_method')}
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
