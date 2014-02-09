<div class="dl40 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o',
        onBeforeDestroy: function(){
            var container = containers[containers.length - 1];
            var container_dg = container.find('.easyui-datagrid');
            var rows = container_dg.datagrid('getRows');
            var index = rows.length + 1;
            var employees_id = $('<input>').attr('name', 'employees_id_' + index).attr('type', 'hidden').val($('#employees_id').val());
            var companies_positions_id = $('<input>').attr('name', 'companies_positions_id_' + index).attr('type', 'hidden').val($('#companies_positions_id').val());
            container.append(employees_id);
            container.append(companies_positions_id);
        }
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"employee"), True, "employees_id")}
            </div>
            <div class="ml15">
                ${h.fields.employees_combobox_field(item.employees_id if item else None, "employees_id")}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"company"), False, "companies_id")}
            </div>
            <div class="ml15">
                <%
                    data_options = """
                        onSelect: function(record){
                            $('#companies_id').val(record.id);
                            $('#companies_structures_id').combotree('reload');
                        }
                    """
                %>
                ${h.fields.companies_combobox_field(item.companies_id if item else None, "companies_id", options=data_options)}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"company structure"), False, "companies_structures_id")}
            </div>
            <div class="ml15">
                <%
                    data_options = """
                        onSelect: function(record){
                            $('#companies_structures_id').val(record.id);
                            $('#companies_positions_id').combobox('reload');
                        }
                    """
                %>
                ${h.fields.company_structures_combotree_field('$("#companies_id").val()', None, "companies_structures_id", options=data_options)}
            </div>
        </div>
        <div class="form-field">
            <div class="dl15">
                ${h.tags.title(_(u"company position"), True, "companies_positions_id")}
            </div>
            <div class="ml15">
                ${h.fields.companies_positions_combobox_field('$("#companies_structures_id").val()', None, "companies_positions_id")}
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
