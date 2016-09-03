<%namespace file="../notes/common.mako" import="note_selector"/>
<%namespace file="../tasks/common.mako" import="task_selector"/>
<%
    _id = h.common.gen_id()
    _form_id = "form-%s" % _id
%>
<div class="dl65 easyui-dialog"
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
        id=_form_id,
        hidden_fields=[('csrf_token', request.session.get_csrf_token())]
    )}
        <script type="easyui-textbox/javascript">
            function calc_active_until_${_id}(){
                if($('#${_form_id} [name=active_until]').val()) return;
                var date = $('#${_form_id} [name=date]').val();
                $.ajax({
                    url: '${request.resource_url(_context, 'invoice_active_until')}',
                    type: 'post',
                    dataType: 'json',
                    data: {
                        'date': date, 
                        'csrf_token': '${request.session.get_csrf_token()}'
                    },
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
                            data_options="onSelect: function(data){calc_active_until_%s();}" % _id
                        )}
                        ${h.common.error_container(name='date')}
                    </div>
                </div>
                <div class="form-field">
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
                        ${h.tags.title(_(u"order"), True, "order_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.orders_combogrid_field(
                            request,
                            'order_id',
                            item.order_id if item else order_id if order_id else None, 
                            show_toolbar=(not readonly if readonly else True),
                        )}
                        ${h.common.error_container(name='order_id')}
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
                            show_toolbar=(not readonly if readonly else True),
                        )}
                        ${h.common.error_container(name='account_id')}
                    </div>
                </div>
                <div class="form-field mb05">
                    <div class="dl15">
                        ${h.tags.title(_(u"description"), False, "descr")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            'descr', 
                            item.descr if item else None, 
                            class_="easyui-textbox w20", 
                            data_options="multiline:true,height:80"
                        )}
                        ${h.common.error_container(name='descr')}
                    </div>
                </div>
            </div>
            <div title="${_(u'Notes')}" data-options="disabled:${h.common.jsonify(not bool(item))}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${note_selector(
                        values=(
                            [note.id for note in item.resource.notes]
                            if item and item.resource else []
                        ),
                        can_edit=(
                            not (readonly if readonly else False) and 
                            (_context.has_permision('add') if item else _context.has_permision('edit'))
                        ) 
                    )}
                </div>
            </div>
            <div title="${_(u'Tasks')}" data-options="disabled:${h.common.jsonify(not bool(item))}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                    ${task_selector(
                        values=(
                            [task.id for task in item.resource.tasks]
                            if item and item.resource else []
                        ),
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
