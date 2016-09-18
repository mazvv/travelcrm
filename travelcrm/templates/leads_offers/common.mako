<%def name="leads_offers_selector(name='lead_offer_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
        _f_id = h.common.gen_id()
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
            url:'/leads_offers/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/leads_offers/details?id=' + row.id, 
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
            <th data-options="field:'service',sortable:true,width:100">${_(u"service")}</th>
            <th data-options="field:'supplier',sortable:true,width:120">${_(u"supplier")}</th>
            <th data-options="field:'price',sortable:true,width:80">${_(u"price")}</th>
            <th data-options="field:'currency',sortable:true,width:60">${_(u"currency")}</th>
            <th data-options="field:'status',sortable:false,width:60,formatter:function(value, row){return status_formatter(value);}">${_(u"status")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'maintainer',width:100,styler:datagrid_resource_cell_styler"><strong>${_(u"maintainer")}</strong></th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for id in values:
            ${h.tags.hidden(name, id)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl45">
            <div class="button-group minor-group">
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/leads_offers/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/leads_offers/copy',property:'with_row'
                    ">
                    ${_(u"Copy")}</a>
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/leads_offers/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
        <div class="ml45 tr" style="padding-top:5px;">
            ${h.common.error_container(name=name)}
        </div>
    </div>
    % endif
</%def>
