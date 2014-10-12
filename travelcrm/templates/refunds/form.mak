<%namespace file="../notes/common.mak" import="notes_selector"/>
<%namespace file="../tasks/common.mak" import="tasks_selector"/>
<%
    _id = h.common.gen_id()
    _form_id = "form-%s" % _id
%>
<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax %s" % ('readonly' if readonly else ''), autocomplete="off", id=_form_id)}
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"payment date"), True, "date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field(item.date if item else None, 'date')}
                        ${h.common.error_container(name='date')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"invoice"), True, "invoice_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.invoices_combobox_field(
                            request, 
                            item.invoice_id if item else None,
                            show_toolbar=(not readonly if readonly else True),
                            options="onSelect: function(index, data){$('#%s .currency').textbox('setValue', data.currency)}" % _form_id)
                        }
                        ${h.common.error_container(name='invoice_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"sum"), True, "sum")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('sum', item.sum if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                        ${h.common.error_container(name='sum')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"sum currency"), False, "currency")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('currency', item.invoice.account.currency.iso_code if item else None, class_="easyui-textbox w20 currency", disabled=True)}
                    </div>
                </div>
            </div>
            <div title="${_(u'Notes')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${notes_selector(
                        values=([note.id for note in item.resource.notes] if item else []),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Tasks')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${tasks_selector(
                        values=([task.id for task in item.resource.tasks] if item else []),
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
                ${h.tags.submit('save', _(u"Save"), class_="button")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
