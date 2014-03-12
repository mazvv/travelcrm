<div class="dl50 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            ${h.tags.hidden('tid', tid)}
            <div title="${_(u'Main')}">
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"first name"), True, "first_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("first_name", item.first_name if item else None, class_="text w20")}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"second name"), False, "second_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("second_name", item.second_name if item else None, class_="text w20")}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"last name"), False, "last_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("last_name", item.last_name if item else None, class_="text w20")}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"position name"), False, "position_name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("position_name", item.position_name if item else None, class_="text w20")}
		            </div>
		        </div>
            </div>
            <div title="${_(u'Contacts')}">
                <div class="_container" style="height:270px;">
                    <table class="easyui-datagrid"
                        id="contacts-dg"
                        data-options="
                            url:'${request.resource_url(_context, 'contacts')}',border:false,
                            pagination:true,fit:true,pageSize:50,singleSelect:true,
                            rownumbers:true,sortName:'id',sortOrder:'desc',
                            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
                            selectOnCheck:false,toolbar:'#contacts-dg-tb',
                            onBeforeLoad: function(param){
                                param.tid = '${tid}';
                                % if item:
                                param.bperson_id = ${item.id};
                                % endif
                            }
                        " width="100%">
                        <thead>
                            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
                            <th data-options="field:'contact',sortable:true,width:250">${_(u"contact")}</th>
                            <th data-options="field:'contact_type',sortable:true,width:150">${_(u"type")}</th>
                        </thead>
                    </table>
                
                    <div class="datagrid-toolbar" id="contacts-dg-tb">
                        <div class="actions button-container">
                            <div class="button-group minor-group">
                                <a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add_contact', query={'tid': tid})}">
                                    <span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
                                </a>
                            </div>
                            <div class="button-group minor-group">
                                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit_contact', query={'tid': tid})}">
                                    <span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
                                </a>
                                <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete_contact', query={'tid': tid})}">
                                    <span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
                                </a>
                            </div>
                        </div>
                    </div>
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
