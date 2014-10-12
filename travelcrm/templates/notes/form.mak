<div class="dl50 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax %s" % ('readonly' if readonly else ''), autocomplete="off")}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            <div title="${_(u'Main')}">
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"title"), True, "title")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("title", item.title if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='title')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Description')}">
                ${h.tags.textarea('descr', item.descr if item else None, id="note-rich-text-editor")}
                <script type="easyui-textbox/javascript">
                    $('#note-rich-text-editor').jqte({"format":false});
                </script>               
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
