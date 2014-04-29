<%namespace file="../common/grid_selectors.mak" import="contacts_selector"/>
<%namespace file="../common/grid_selectors.mak" import="addresses_selector"/>
<%namespace file="../common/grid_selectors.mak" import="banks_details_selector"/>
<div class="dl60 easyui-dialog"
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
		                 ${h.tags.title(_(u"name"), True, "name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("name", item.name if item else None, class_="text w20")}
		                ${h.common.error_container(name='name')}
		            </div>
		        </div>
		        <div class="form-field mb05">
		            <div class="dl15">
		                ${h.tags.title(_(u"parent structure"), False, "parent_id")}
		            </div>
		            <div class="ml15">
		                ${h.fields.structures_combotree_field(item.parent_id if item else None)}
		                ${h.common.error_container(name='parent_id')}
		            </div>
		        </div>
            </div>
            <div title="${_(u'Contacts')}">
                ${contacts_selector(
                    values=([contact.id for contact in item.contacts] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
                )}
            </div>
            <div title="${_(u'Addresses')}">
                ${addresses_selector(
                    values=([address.id for address in item.addresses] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
                )}
            </div>
            <div title="${_(u'Banks Details')}">
                ${banks_details_selector(
                    values=([bank_detail.id for bank_detail in item.banks_details] if item else []),
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
