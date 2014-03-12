<div class="dl50 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        ${h.tags.hidden('tid', tid)}
        <div class="easyui-tabs h100" data-options="border:false,height:300">
            <div title="${_(u'Main')}">
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"name"), True, "name")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("name", item.name if item else None, class_="text w20")}
		            </div>
		        </div>
				<div class="form-field">
					<div class="dl15">
						${h.tags.title(_(u"status"), True, "status")}
					</div>
					<div class="ml15">
						${h.fields.status_field(item.resource.status if item else None)}
					</div>
				</div>
		    </div>
		    <div title="${_(u'Licences')}" data-options="href:'/licences/field?ref_name=touroperator${'&ref_id=%s' % item.id if item else ''}'">
		    </div>
            <div title="${_(u'Contacts')}">
                <div class="_container" style="height:270px;">
                    <table class="easyui-datagrid"
                        id="touroperators-bpersons-dg"
                        data-options="
                            url:'${request.resource_url(_context, 'bpersons')}',border:false,
                            pagination:true,fit:true,pageSize:50,singleSelect:true,
                            rownumbers:true,sortName:'id',sortOrder:'desc',
                            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
                            selectOnCheck:false,toolbar:'#touroperators-bpersons-dg-tb',
                            onBeforeLoad: function(param){
                                param.tid = '${tid}';
                                % if item:
                                param.touroperator_id = ${item.id};
                                % endif
                            }
                        " width="100%">
                        <thead>
                            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
                            <th data-options="field:'name',sortable:true,width:200">${_(u"name")}</th>
                            <th data-options="field:'position_name',sortable:true,width:200">${_(u"position")}</th>
                        </thead>
                    </table>
                
                    <div class="datagrid-toolbar" id="touroperators-bpersons-dg-tb">
                        <div class="actions button-container">
                            <div class="button-group minor-group">
                                <a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add_bperson', query={'tid': tid})}">
                                    <span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
                                </a>
                            </div>
                            <div class="button-group minor-group">
                                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit_bperson', query={'tid': tid})}">
                                    <span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
                                </a>
                                <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete_bperson', query={'tid': tid})}">
                                    <span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div title="${_(u'History')}">
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
