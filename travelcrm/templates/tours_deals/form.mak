<%namespace file="../common/grid_selectors.mak" import="persons_selector"/>
<%namespace file="../common/grid_selectors.mak" import="tour_points_selector"/>
<div class="dl75 easyui-dialog"
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
						${h.tags.title(_(u"status"), True, "status")}
					</div>
					<div class="ml15">
						${h.fields.status_field(item.resource.status if item else None)}
						${h.common.error_container(name='status')}
					</div>
				</div>
		    </div>
		    <div title="${_(u'Tour')}">
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
                        ${h.tags.title(_(u"adults"), True, "adults")}
                    </div>
                    <div class="dl20">
                        ${h.tags.text('adults', item.adults if item else 0, class_="text w5 easyui-numberspinner", data_options="min:0,precision:0,editable:false")}
                        ${h.common.error_container(name='adults')}
                    </div>
                    <div class="dl15">
                        ${h.tags.title(_(u"children"), True, "children")}
                    </div>
                    <div class="ml50">
                        ${h.tags.text('children', item.children if item else 0, class_="text w5 easyui-numberspinner", data_options="min:0,precision:0,editable:false")}
                        ${h.common.error_container(name='children')}
                    </div>
                </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"price"), True, "price")}
		            </div>
		            <div class="dl20">
		                ${h.tags.text('price', item.price if item else None, class_="text w10 easyui-numberbox", data_options="min:0,precision:2")}
		                ${h.common.error_container(name='price')}
		            </div>
		            <div class="dl15">
		                ${h.tags.title(_(u"price currency"), True, "currency_id")}
		            </div>
		            <div class="ml50">
		                ${h.fields.currencies_combobox_field(request, item.currency_id if item else None)}
		                ${h.common.error_container(name='currency_id')}
		            </div>
		        </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"start"), True, "start_dt")}
                    </div>
                    <div class="dl20">
                        ${h.fields.datetime_field(item.start_dt if item else None, 'start_dt')}
                        ${h.common.error_container(name='start_dt')}
                    </div>
                    <div class="dl15">
                        ${h.tags.title(_(u"start point"), True, "start_location_id")}
                    </div>
                    <div class="ml50">
                        ${h.fields.locations_combobox_field(request, item.start_location_id if item else None, 'start_location_id')}
                        ${h.common.error_container(name='start_location_id')}
                    </div>
                </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"end"), True, "end_dt")}
                    </div>
                    <div class="dl20">
                        ${h.fields.datetime_field(item.end_dt if item else None, 'end_dt')}
                        ${h.common.error_container(name='end_dt')}
                    </div>
                    <div class="dl15">
                        ${h.tags.title(_(u"end point"), True, "end_location_id")}
                    </div>
                    <div class="ml50">
                        ${h.fields.locations_combobox_field(request, item.end_location_id if item else None, 'end_location_id')}
                        ${h.common.error_container(name='end_location_id')}
                    </div>
                </div>
                ${h.common.error_container(name='tour_point_id', as_text=True)}
                ${tour_points_selector(
                    values=([point.id for point in item.points] if item else []),
                    can_edit=(_context.has_permision('edit') if item else _context.has_permision('add')) 
                )}
		    </div>
            <div title="${_(u'Members')}">
                ${persons_selector(
                    values=([person.id for person in item.persons] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
                )}
            </div>
            <div title="${_(u'Billing')}">
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
