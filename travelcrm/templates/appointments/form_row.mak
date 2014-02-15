<div class="dl40 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax _container_storage", autocomplete="off")}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"employee"), True, "employee_id")}
            </div>
            <div class="ml15">
                ${h.fields.employees_combobox_field(item.employee_id if item else None, "employee_id")}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"company structure"), False, "structure_id")}
            </div>
            <div class="ml15">
                <%
                    data_options = """
                        onSelect: function(record){
                            $('#structure_id').val(record.id);
                            $('#position_id').combobox('reload');
                        }
                    """
                %>
                ${h.fields.structures_combotree_field(None, "structure_id", options=data_options)}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"company position"), True, "position_id")}
            </div>
            <div class="ml15">
                ${h.fields.positions_combobox_field('$("#structure_id").val()', None, "position_id")}
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
