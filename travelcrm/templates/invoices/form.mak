<%namespace file="../common/infoblock.mak" import="infoblock"/>
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
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off", id=_form_id)}
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
        </script>
        <div class="form-field mt05">
            <div class="dl15">
                ${h.tags.title(_(u"invoice date"), True, "date")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.date if item else None, 'date', options="onSelect: function(index, data){calc_sum_%s();}" % _id)}
                ${h.common.error_container(name='date')}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"account"), True, "account_id")}
            </div>
            <div class="ml15">
                ${h.fields.accounts_combobox_field(
                    request, item.account_id if item else None, 
                    show_toolbar=False, structure_id=structure_id,
                    options="onSelect: function(index, data){calc_sum_%s();}" % _id
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
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr button-group">
                ${h.tags.submit('save', _(u"Save"), class_="button")}
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
