<%namespace file="../tours/common.mak" import="tour_points_selector"/>
<%namespace file="../persons/common.mak" import="persons_selector"/>
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
        <div class="easyui-tabs" data-options="border:false,height:400">
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
			   	<div class="form-field mb05">
				    <div class="dl15">
				        ${h.tags.title(_(u"tour service"), True, "service_id")}
	  	            </div>
	  	            <div class="ml15">
		  		        ${h.fields.services_combobox_field(request, item.service_id if item else None)}
		  		        ${h.common.error_container(name='service_id')}
	  	            </div>
	  	        </div>
				<div class="form-field">
				    <div class="dl15">
				        ${h.tags.title(_(u"touroperator"), True, "touroperator_id")}
				    </div>
				    <div class="ml15">
				        ${h.fields.touroperators_combobox_field(request, item.touroperator_id if item else None)}
				        ${h.common.error_container(name='touroperator_id')}
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
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"adults"), True, "adults")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('adults', item.adults if item else 0, class_="easyui-textbox w5 easyui-numberspinner", data_options="min:0,precision:0,editable:false")}
                        ${h.common.error_container(name='adults')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"children"), True, "children")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text('children', item.children if item else 0, class_="easyui-textbox w5 easyui-numberspinner", data_options="min:0,precision:0,editable:false")}
                        ${h.common.error_container(name='children')}
                    </div>
                </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"price"), True, "price")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text('price', item.price if item else None, class_="easyui-textbox w20 easyui-numberbox", data_options="min:0,precision:2")}
		                ${h.common.error_container(name='price')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"price currency"), True, "currency_id")}
		            </div>
		            <div class="ml15">
		                ${h.fields.currencies_combobox_field(request, item.currency_id if item else None)}
		                ${h.common.error_container(name='currency_id')}
		            </div>
		        </div>
		    </div>
		    <div title="${_(u'Route')}">
                <div class="form-field">
                    <div class="dl10">
                        ${h.tags.title(_(u"start"), True, "start_date")}
                    </div>
                    <div class="dl20">
                        ${h.fields.date_field(item.start_date if item else None, 'start_date')}
                        ${h.common.error_container(name='start_date')}
                    </div>
                    <div class="dl10">
                        ${h.tags.title(_(u"start point"), True, "start_location_id")}
                    </div>
                    <div class="ml40">
                        ${h.fields.locations_combobox_field(request, item.start_location_id if item else None, 'start_location_id')}
                        ${h.common.error_container(name='start_location_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl10">
                        ${h.tags.title(_(u"end"), True, "end_date")}
                    </div>
                    <div class="dl20">
                        ${h.fields.date_field(item.end_date if item else None, 'end_date')}
                        ${h.common.error_container(name='end_date')}
                    </div>
                    <div class="dl10">
                        ${h.tags.title(_(u"end point"), True, "end_location_id")}
                    </div>
                    <div class="ml40">
                        ${h.fields.locations_combobox_field(request, item.end_location_id if item else None, 'end_location_id')}
                        ${h.common.error_container(name='end_location_id')}
                    </div>
                </div>
                <div class="easyui-panel" data-options="fit:true,border:false">
	                ${tour_points_selector(
	                    values=([point.id for point in item.points] if item else []),
	                    can_edit=(_context.has_permision('edit') if item else _context.has_permision('add')) 
	                )}
                </div>
		    </div>
            <div title="${_(u'Members')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
                ${persons_selector(
                    values=([person.id for person in item.persons] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
                )}
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
