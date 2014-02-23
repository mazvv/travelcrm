<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        ${h.tags.hidden('tid', tid)}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"appointment date"), True, "appointment_date")}
            </div>
            <div class="ml15">
                ${h.fields.date_field(item.appointment_date if item else None, "appointment_date")}
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
        <div class="document-rows _container" style="height:300px;">
		    <table class="easyui-datagrid"
		        id="employees-appointments-rows-dg"
		        data-options="
		        	url:'${request.resource_url(_context, 'rows')}',border:false,
		        	pagination:true,fit:true,pageSize:50,singleSelect:true,
		            rownumbers:true,sortName:'id',sortOrder:'desc',
		            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
		            selectOnCheck:false,toolbar:'#employees-appointments-rows-dg-tb',
		            onBeforeLoad: function(param){
		                param.tid = '${tid}';
		                % if item:
		                param.appointment_id = ${item.id};
		                % endif
		            }
		        " width="100%">
		        <thead>
		            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
		            <th data-options="field:'employee_name',sortable:true,width:150">${_(u"employee")}</th>
		            <th data-options="field:'position_name',sortable:true,width:150">${_(u"position")}</th>
		            <th data-options="field:'structure_name',sortable:true,width:150">${_(u"structure")}</th>
		        </thead>
		    </table>
		
		    <div class="datagrid-toolbar" id="employees-appointments-rows-dg-tb">
		        <div class="actions button-container">
		            <div class="button-group minor-group">
						<a href="#" class="button primary _dialog_open" data-url="${request.resource_url(_context, 'add_row', query={'tid': tid})}">
						    <span class="fa fa-plus"></span> <span>${_(u"Add New")}</span>
						</a>
					</div>
					<div class="button-group minor-group">
		                <a href="#" class="button _dialog_open _with_row" data-url="${request.resource_url(_context, 'edit_row', query={'tid': tid})}">
		                    <span class="fa fa-pencil"></span> <span>${_(u"Edit")}</span>
		                </a>
	                    <a href="#" class="button danger _dialog_open _with_rows" data-url="${request.resource_url(_context, 'delete_row', query={'tid': tid})}">
	                        <span class="fa fa-times"></span> <span>${_(u"Delete")}</span>
	                    </a>
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
