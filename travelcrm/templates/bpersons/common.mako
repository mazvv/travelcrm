<%namespace file="../contacts/common.mako" import="contact_list_details"/>
<%def name="bperson_selector(name='bperson_id', values=[], can_edit=True, style=None)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="easyui-textbox/javascript">
        function add_${_func_id}(input_id){
            var id = $('#' + input_id).combogrid('getValue');
            if(is_int(id)){
                var input = $('<input type="hidden" name="${name}">').val(id);
                input.appendTo('#${_storage_id}');
                $('#' + input_id).combogrid('clear');
                $('#${_id}').datagrid('reload');
            }
            return false;
        }
        function delete_${_func_id}(grid_id){
            var rows = get_checked($('#' + grid_id));
            $.each(rows, function(i, row){
                $('#${_storage_id} input[name=${name}][value=' + row.id + ']').remove();
            });
            $('#' + grid_id).datagrid('reload');
            return false;
        }
    </script>
    % endif
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'/bpersons/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/bpersons/details?id=' + row.id, 
                    function(){
                        $('#${_id}').datagrid('fixDetailRowHeight', index);
                        $('#${_id}').datagrid('fixRowHeight', index);
                        $.parser.parse('#' + row_id);
                    }
                );
            },
            detailFormatter: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                return '<div id=' + row_id + '></div>';
            },          
            onBeforeLoad: function(param){
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
            <th data-options="field:'name',sortable:true,width:150">${_(u"name")}</th>
            <th data-options="field:'position_name',sortable:true,width:150">${_(u"position name")}</th>
            <th data-options="field:'status',sortable:false,width:70,formatter:function(value, row){return status_formatter(value);}">${_(u"status")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for bperson in values:
            ${h.tags.hidden(name, bperson)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <div style="display: inline-block;padding-top:2px;">
                <%
                    f_id = h.common.gen_id()
                %>
                ${h.fields.bpersons_combogrid_field(request, f_id, id=f_id)}
            </div>
            <div class="button-group minor-group ml1">
                <a href="#" class="button easyui-linkbutton" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                % if 'edit' in h.permisions.get_bpersons_permisions(request):
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/bpersons/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                % endif
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


<%def name="bperson_list_details(bperson)">
    <span class="mr05">${bperson.name}</span>
    ${contact_list_details(bperson.contacts)}
</%def>
