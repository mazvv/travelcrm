<%namespace file="../contacts/common.mak" import="contacts_selector"/>
<%namespace file="../addresses/common.mak" import="addresses_selector"/>
<%namespace file="../banks_details/common.mak" import="banks_details_selector"/>
<%namespace file="../accounts/common.mak" import="accounts_selector"/>
<div class="dl60 easyui-dialog"
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
                <div class="easyui-panel" data-options="fit:true,border:false">
	                ${contacts_selector(
	                    values=([contact.id for contact in item.contacts] if item else []),
	                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
	                )}
                </div>
            </div>
            <div title="${_(u'Addresses')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
	                ${addresses_selector(
	                    values=([address.id for address in item.addresses] if item else []),
	                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
	                )}
                </div>
            </div>
            <div title="${_(u'Banks Details')}">
                <div class="easyui-panel" data-options="fit:true,border:false">
	                ${banks_details_selector(
	                    values=([bank_detail.id for bank_detail in item.banks_details] if item else []),
	                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
	                )}
                </div>
            </div>
            <div title="${_(u'Accounts')}">
                <div class="easyui-panel" data-options="fit:true,border:false">            
	                ${accounts_selector(
	                    values=([account.id for account in item.accounts] if item else []),
	                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
	                )}
                </div>
            </div>
            <div title="${_(u'Invoice Template')}">
                ${h.tags.textarea('invoice_template', item.invoice_template if item else None, style="width: 715px;border:none;height:300px;outline:none;", class_="text")}
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
