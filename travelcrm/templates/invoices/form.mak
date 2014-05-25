<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        % if not item:
            ${h.tags.hidden('invoice_resource_id', resource_id)}
        % endif
        <div class="easyui-tabs h100" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"invoice date"), True, "date")}
		            </div>
		            <div class="ml15">
		                ${h.fields.date_field(item.date if item else None, 'date')}
		                ${h.common.error_container(name='date')}
		            </div>
		        </div>
		        <div class="form-field mb05">
		            <div class="dl15">
		                ${h.tags.title(_(u"beneficiary"), True, "bank_detail_id")}
		            </div>
		            <div class="ml15">
		                ${h.fields.banks_details_combobox_field(
		                    request, item.bank_detail_id if item else None, 
		                    show_toolbar=False, structure_id=structure_id
		                )}
		                ${h.common.error_container(name='bank_detail_id')}
		            </div>
		        </div>
	        </div>
	        <div title="${_(u'Info')}">
                
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
