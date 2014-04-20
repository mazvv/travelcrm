<div class="dl50 easyui-dialog"
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
		                ${h.tags.title(_(u"title"), True, "title")}
		            </div>
		            <div class="ml15">
		                ${h.tags.text("title", item.title if item else None, class_="text w20")}
		                ${h.common.error_container(name='title')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"performer"), True, "employee_id")}
		            </div>
		            <div class="ml15">
		                ${h.fields.employees_combobox_field(request, item.employee_id if item else None)}
		                ${h.common.error_container(name='employee_id')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"reminder"), False, "reminder")}
		            </div>
		            <div class="ml15">
		                ${h.fields.date_field(item.reminder_date if item else None, 'reminder_date')}
		                ${h.fields.time_field(item.reminder_time if item else None, 'reminder_time')}
		                ${h.common.error_container(name='reminder_date')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"deadline"), True, "deadline")}
		            </div>
		            <div class="ml15">
		                ${h.fields.date_field(item.deadline if item else None, 'deadline')}
		                ${h.common.error_container(name='deadline')}
		            </div>
		        </div>
		        <div class="form-field">
		            <div class="dl15">
		                ${h.tags.title(_(u"priority"), True, "priority")}
		            </div>
		            <div class="ml15">
		                ${h.fields.tasks_priority_combobox_field(request, item.priority if item else None)}
		                ${h.common.error_container(name='priority')}
		            </div>
		        </div>
                <div class="form-field">
                    <div class="dl15">
                        ${h.tags.title(_(u"closed"), True, "closed")}
                    </div>
                    <div class="ml15">
                        ${h.fields.yes_no_field(int(item.closed) if item else None, 'closed')}
                        ${h.common.error_container(name='closed')}
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
            <div title="${_(u'Description')}">
                ${h.tags.textarea('descr', item.descr if item else None, id="task-rich-text-editor")}
                <script type="text/javascript">
                    $('#task-rich-text-editor').jqte({"format":false});
                </script>               
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
