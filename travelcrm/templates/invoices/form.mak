<%namespace file="../common/infoblock.mak" import="infoblock"/>
<%namespace file="../note/common.mak" import="note_selector"/>
<%namespace file="../task/common.mak" import="task_selector"/>
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
    ${h.tags.form(
        request.url, 
        class_="_ajax %s" % ('readonly' if readonly else ''), 
        autocomplete="off", 
        id=_form_id,
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <script type="easyui-textbox/javascript">
            function calc_sum_${_id}(){
                var resource_id = ${resource_id};
                var date = $('#${_form_id} [name=date]').val();
                var account_id = $('#${_form_id} [name=account_id]').val();
                $.ajax({
                    url: '${request.resource_url(_context, 'invoice_sum')}',
                    type: 'post',
                    dataType: 'json',
                    data: {'resource_id': resource_id, 'date': date, 'account_id': account_id},
                    success: function(json){
                        if(json.invoice_sum) $('#${_form_id} .invoice_sum').textbox('setValue', json.currency + ' ' + json.invoice_sum);
                    }
                });
            }
            function calc_active_until_${_id}(){
                if($('#${_form_id} [name=active_until]').val()) return;
                var date = $('#${_form_id} [name=date]').val();
                $.ajax({
                    url: '${request.resource_url(_context, 'invoice_active_until')}',
                    type: 'post',
                    dataType: 'json',
                    data: {'date': date},
                    success: function(json){
                        if(json.active_until) $('#${_form_id} .easyui-datebox:eq(1)').datebox('setValue', json.active_until);
                    }
                });
            }
        </script>
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field mt05">
                    <div class="dl15">
                        ${h.tags.title(_(u"invoice date"), True, "date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field(
                            'date',
                            item.date if item else None, 
                            date_options="onSelect: function(index, data){calc_sum_%s();calc_active_until_%s();}" % (_id, _id)
                        )}
                        ${h.common.error_container(name='date')}
                    </div>
                </div>
                <div class="form-field mb05 mt1">
                    <div class="dl15">
                        ${h.tags.title(_(u"active until"), True, "active until")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field(
                            'active_until',
                            item.active_until if item else None,
                        )}
                        ${h.common.error_container(name='active_until')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"account"), True, "account_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.accounts_combogrid_field(
                            request,
                            'account_id',
                            item.account_id if item else None, 
                            show_toolbar=False,
                            data_options="onSelect: function(index, data){calc_sum_%s();}" % _id,
                        )}
                        ${h.common.error_container(name='account_id')}
                    </div>
                </div>
                ${infoblock(_(u"Automaticaly calculated"))}
                <div class="form-field mb05 mt1">
                    <div class="dl15">
                        ${h.tags.title(_(u"invoice sum"), false, "invoice_sum")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('invoice_sum', '', class_="easyui-textbox w20 invoice_sum", disabled=True)}
                    </div>
                </div>
                % if item:
                <script type="easyui-textbox/javascript">
                    calc_sum_${_id}();
                </script>
                % endif
            </div>
            <div title="${_(u'Notes')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${note_selector(
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
                    ${task_selector(
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
