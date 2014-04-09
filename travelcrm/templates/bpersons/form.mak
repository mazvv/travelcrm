<%namespace file="../common/grid_selectors.mak" import="contacts_selector"/>
<div class="dl55 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            <div title="${_(u'Main')}">
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"first name"), True, "first_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("first_name", item.first_name if item else None, class_="text w20")}
		                ${h.common.error_container(name='first_name')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"second name"), False, "second_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("second_name", item.second_name if item else None, class_="text w20")}
		                ${h.common.error_container(name='second_name')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
						${h.tags.title(_(u"last name"), False, "last_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("last_name", item.last_name if item else None, class_="text w20")}
		                ${h.common.error_container(name='last_name')}
		            </div>
		        </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"position name"), True, "position_name")}
                    </div>
                    <div class="ml15">
                        ${h.tags.text("position_name", item.position_name if item else None, class_="text w20")}
                        ${h.common.error_container(name='position_name')}
                    </div>
                </div>
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
		    <div title="${_(u'Contacts')}">
                ${contacts_selector(
                    values=([contact.id for contact in item.contacts] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
                )}
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
