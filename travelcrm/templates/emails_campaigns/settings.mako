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
                ${h.tags.title(_(u"timeout"), True, "timeout")}
            </div>
            <div class="ml15">
                  ${h.tags.text(
                      'timeout',
                      rt.settings.get("timeout") if rt.settings else None,
                      class_='easyui-numberbox w10',
                      data_options="suffix:' %s'" % _(u'sec.')
                  )}
                  ${h.common.error_container(name='service_id')}
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
