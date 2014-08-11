<%
    _id = h.common.gen_id()
    _form_id = "form-%s" % _id
%>
<div class="dl45 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off", id=_form_id)}
        <script type="easyui-textbox/javascript">
            function currency_${_id}(){
                var invoice_id = $('#${_form_id} [name=invoice_id]').val();
                $.ajax({
                    url: '${request.resource_url(_context, 'currency')}',
                    type: 'post',
                    dataType: 'json',
                    data: {'invoice_id': invoice_id},
                    success: function(json){
                    	console.log(json);
                        if(json.currency) 
                            $('#${_form_id} [name=currency]').val(json.currency);
                    }
                });
            }
        </script>
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
                ${h.fields.invoices_combobox_field(request, item.invoice_id if item else None, options="onSelect: function(){currency_%s();}" % _id)}
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
                ${h.tags.text('currency', item.invoice.account.currency.iso_code if item else None, class_="easyui-textbox w20", disabled=True)}
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
