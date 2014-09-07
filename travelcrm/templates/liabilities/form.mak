<%namespace file="../liabilities_items/common.mak" import="liabilities_items_selector"/>
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
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
		        <div class="form-field mt05">
		            <div class="dl15">
		                ${h.tags.title(_(u"liability date"), True, "date")}
		            </div>
		            <div class="ml15">
		                ${h.fields.date_field(item.date if item else None, 'date', options="onSelect: function(index, data){calc_sum_%s();}" % _id)}
		                ${h.common.error_container(name='date')}
		            </div>
		        </div>
            </div>
            <div title="${_(u'Liability Items')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                ${liabilities_items_selector(
                    values=([liability_item.id for liability_item in item.liabilities_items] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')),
                    resource_id=resource_id,
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
