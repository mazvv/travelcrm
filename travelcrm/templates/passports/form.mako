<%namespace file="../uploads/common.mako" import="uploads_selector"/>
<div class="dl50 easyui-dialog"
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
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"passport type"), True, "passport type")}
                    </div>
                    <div class="ml15">
                        ${h.fields.passport_type_field('passport_type', item.passport_type.key if item else None)}
                        ${h.common.error_container(name='passport_type')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"passport num"), True, "num")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("num", item.num if item else None, class_="easyui-textbox w20")}
                        ${h.common.error_container(name='num')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"country"), True, "country")}
                    </div>
                    <div class="ml15">
                        ${h.fields.countries_combogrid_field(
                            request,
                            'country_id',
                            item.country_id if item else None,
                            show_toolbar=(not readonly if readonly else True)
                        )}
                        ${h.common.error_container(name='country_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"end date"), False, "end_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field('end_date', item.end_date if item else None)}
                        ${h.common.error_container(name='end_date')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"description"), False, "descr")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('descr', item.descr if item else None, class_="easyui-textbox w20", data_options="multiline:true,height:80")}
                        ${h.common.error_container(name='descr')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Uploads')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${uploads_selector(
                        values=([upload.id for upload in item.uploads] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>                
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
