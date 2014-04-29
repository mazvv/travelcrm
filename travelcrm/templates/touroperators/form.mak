<%namespace file="../common/grid_selectors.mak" import="bpersons_selector"/>
<%namespace file="../common/grid_selectors.mak" import="licences_selector"/>
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
		    </div>
		    <div title="${_(u'Licences')}">
                ${licences_selector(
                    values=([licence.id for licence in item.licences] if item else []),
                    can_edit=(_context.has_permision('add') if item else _context.has_permision('edit')) 
                )}
		    </div>
            <div title="${_(u'Contacts')}">
                ${bpersons_selector(
                    values=([bperson.id for bperson in item.bpersons] if item else []),
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
