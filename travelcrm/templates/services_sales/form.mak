<%namespace file="../services_items/common.mak" import="services_items_selector"/>
<div class="dl70 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="easyui-tabs h100" data-options="border:false,height:400">
            <div title="${_(u'Main')}">
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"deal date"), True, "deal_date")}
                    </div>
                    <div class="ml15">
                        ${h.fields.date_field(item.deal_date if item else None, 'deal_date')}
                        ${h.common.error_container(name='deal_date')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"advertise"), True, "advsource_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.advsources_combobox_field(request, item.advsource_id if item else None)}
                        ${h.common.error_container(name='advsource_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"customer"), True, "customer_id")}
                    </div>
                    <div class="ml15">
                        ${h.fields.persons_combobox_field(request, item.customer_id if item else None, name="customer_id")}
                        ${h.common.error_container(name="customer_id")}
                    </div>
                </div>
		    </div>
            <div title="${_(u'Services Items')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
					${services_items_selector(
					    values=([service_item.id for service_item in item.services_items] if item else []),
					    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
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
