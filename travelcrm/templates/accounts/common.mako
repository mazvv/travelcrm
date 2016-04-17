<%def name="accounts_selector(name='account_id', values=[], can_edit=True)">
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
    <script type="easyui-textbox/javascript">
        function formatter_${_func_id}(index, row){
            var html = '<table width="100%" class="grid-details">';
            if(row.display_text){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'display text')}</td>'
                    + '<td>' + row.display_text + '</td>'
                    + '</tr>';
            }
            if(row.descr){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'description')}</td>'
                    + '<td>' + row.descr + '</td>'
                    + '</tr>';
            }
            html += '</table>';
            return html;
        }
    </script>
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'/accounts/list',border:false,
            singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            detailFormatter: function(index, row){
                return formatter_${_func_id}(index, row);
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
            <th data-options="field:'name',sortable:true,width:200">${_(u"name")}</th>
            <th data-options="field:'account_type',sortable:true,width:100">${_(u"account type")}</th>
            <th data-options="field:'currency',sortable:true,width:60">${_(u"currency")}</th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for account in values:
            ${h.tags.hidden(name, account)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl40">
            <div style="display: inline-block;padding-top:2px;">
                <%
                    f_id = h.common.gen_id()
                %>
                ${h.fields.accounts_combogrid_field(
                    request, f_id, id=f_id
                )}
            </div>
            <div class="button-group minor-group ml1">
                <a href="#" class="button easyui-linkbutton" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                % if 'edit' in h.permisions.get_accounts_permisions(request):
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/accounts/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                % endif
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
        <div class="ml35 tr" style="padding-top: 5px;">
            ${h.common.error_container(name=name)}
        </div>
    </div>
    % endif
</%def>


<%def name="account_list_details(account)">
    <span class="mr05">
        ${account.name}, ${account.currency.iso_code}, ${account.account_type.title}
    </span>
</%def>
