<div class="dl45 easyui-dialog"
    title="${title}"
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
        multipart=True,
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="form-field mt05">
            <div class="dl15">
                ${h.tags.title(_(u"upload"), True, "upload")}
            </div>
            <div class="ml15">
                ${h.tags.text(
                    'upload',
                    None, 
                    class_='easyui-filebox w20',
                    data_options="buttonText: '%s'" % _(u'Choose File')
                )}
                ${h.common.error_container(name='upload')}
            </div>
        </div>
        <div class="form-field mb05">
            <div class="dl15">
                 ${h.tags.title(_(u"description"), False, "descr")}
            </div>
            <div class="ml15">
                ${h.tags.text(
                    "descr", 
                    item.descr if item else None, 
                    class_="easyui-textbox w20", 
                    data_options="multiline:true,height:80",
                )}
                ${h.common.error_container(name='descr')}
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
