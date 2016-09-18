<%def name="contact_selector(name='contact_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="easyui-textbox/javascript">
        function add_${_func_id}(id){
            if(is_int(id)){
                var input = $('<input type="hidden" name="${name}">').val(id);
                input.appendTo('#${_storage_id}');
            }
            return false;
        }
        function delete_${_func_id}(grid_id){
            var rows = get_checked($('#' + grid_id));
            if(rows.length > 0){
                $.each(rows, function(i, row){
                    $('#${_storage_id} input[name=${name}][value=' + row.id + ']').remove();
                });
                $('#' + grid_id).datagrid('reload');
            }
            return false;
        }
    </script>
    % endif
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'/contacts/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(param){
                var response = $(this).data('response');
                % if can_edit:
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
                % endif
                var id = [0];
                $.each($('#${_storage_id} input[name=${name}]'), function(i, el){
                    id.push($(el).val());
                });
                param.id = id.join();                            
                param.rows = 0;
                param.page = 0;
            }
        " width="100%">
        <thead>
            % if can_edit:
                <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th align="center" data-options="field:'contact_type',width:20,formatter:function(value){return format_contact_type(value.key);}"></th>
            <th data-options="field:'contact',sortable:true,width:200">${_(u"contact")}</th>
            <th data-options="field:'status',sortable:false,width:70,formatter:function(value, row){return status_formatter(value);}">${_(u"status")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for point in values:
            ${h.tags.hidden(name, point)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <%
                f_id = h.common.gen_id()
            %>
            <div class="button-group minor-group">
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/contacts/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/contacts/copy',property:'with_row'
                    ">
                    ${_(u"Copy")}</a>
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/contacts/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


<%def name="contact_list_details(contacts)">
    <%
        contacts = map(
            lambda x: (
                h.common.contact_type_icon(x.contact_type), x.contact
            ),
            [contact for contact in contacts if contact.is_status_active()]
        )
    %>
    % if contacts:
        % for icon, contact in contacts:
            ${icon} <span class="mr1">${contact}</span>
        % endfor
    % endif
</%def>
