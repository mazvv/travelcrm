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
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"date"), True, "date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field(item.cashflow.date if item else None, 'date')}
                        ${h.common.error_container(name='date')}
                    </div>
                </div>
                % if not readonly:
                    ${infoblock(_(u"You need to fill at least one account or subaccount and not both from section"))}
                % else:
                	<div class="delimiter-block"></div>
                % endif
                <div class="easyui-tabs" data-options="border:false,height:78,tabPosition:'right'">
	                <div title="${_(u'From')}" data-options="iconCls:'fa fa-arrow-circle-left'">
		                <div class="form-field">
		                    <div class="dl15">
		                        ${h.tags.title(_(u"account from"), False, "account_from_id")}
		                    </div>
		                    <div class="ml15">
		                        ${h.fields.accounts_combobox_field(
		                            request,
		                            item.cashflow.account_from_id if item else None,
		                            name='account_from_id',
		                            show_toolbar=(not readonly if readonly else True),
		                            options="onSelect: function(index, data){$('#%s .currency').textbox('setValue', data.currency)}" % _form_id,
		                        )}
		                        ${h.common.error_container(name='account_from_id')}
		                    </div>
		                </div>
		                <div class="form-field">
		                    <div class="dl15">
		                        ${h.tags.title(_(u"subaccount from"), False, "subaccount_from_id")}
		                    </div>
		                    <div class="ml15">
		                        ${h.fields.subaccounts_combobox_field(
		                            request,
		                            item.cashflow.subaccount_from_id if item else None,
		                            name='subaccount_from_id',
		                            show_toolbar=(not readonly if readonly else True),
		                            options="onSelect: function(index, data){$('#%s .currency').textbox('setValue', data.currency)}" % _form_id,
		                        )}
		                        ${h.common.error_container(name='subaccount_from_id')}
		                    </div>
		                </div>
	                </div>
	                <div title="${_(u'To')}" data-options="iconCls:'fa fa-arrow-circle-right'">
		                <div class="form-field">
		                    <div class="dl15">
		                        ${h.tags.title(_(u"account to"), False, "account_to_id")}
		                    </div>
		                    <div class="ml15">
		                        ${h.fields.accounts_combobox_field(
		                            request, 
		                            item.cashflow.account_to_id if item else None,
		                            name='account_to_id',
		                            show_toolbar=(not readonly if readonly else True),
		                            options="onSelect: function(index, data){$('#%s .currency').textbox('setValue', data.currency)}" % _form_id,
		                        )}
		                        ${h.common.error_container(name='account_to_id')}
		                    </div>
		                </div>
		                <div class="form-field">
		                    <div class="dl15">
		                        ${h.tags.title(_(u"subaccount to"), False, "subaccount_to_id")}
		                    </div>
		                    <div class="ml15">
		                        ${h.fields.subaccounts_combobox_field(
		                            request, 
		                            item.cashflow.subaccount_to_id if item else None,
		                            name='subaccount_to_id',
		                            show_toolbar=(not readonly if readonly else True),
		                            options="onSelect: function(index, data){$('#%s .currency').textbox('setValue', data.currency)}" % _form_id,
		                        )}
		                        ${h.common.error_container(name='subaccount_to_id')}
		                    </div>
		                </div>
	                </div>
                </div>
                <div class="delimiter-block" style="margin-top: 0px;"></div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"account item"), True, "account_item_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.accounts_items_combobox_field(
                            request,
                            item.cashflow.account_item_id if item else None,
                            show_toolbar=(not readonly if readonly else True)
                        )}
                        ${h.common.error_container(name='account_item_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"sum"), True, "sum")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('sum', item.cashflow.sum if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
                        ${h.common.error_container(name='sum')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"currency"), False, "currency")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text(
                            'from_currency', 
                            item.cashflow.currency.iso_code if item else None, 
                            class_="easyui-textbox w20 currency", 
                            disabled=True
                        )}
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
