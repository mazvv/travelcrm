<%def name="commission_selector(name='commission_id', values=[], can_edit=True)">
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
            url:'/commissions/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'service',sortOrder:'asc',
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
            <th data-options="field:'service',sortable:true,width:150">${_(u"service")}</th>
            <th data-options="field:'percentage',sortable:true,width:60">${_(u"percent")}</th>
            <th data-options="field:'price',sortable:true,width:80">${_(u"price")}</th>
            <th data-options="field:'currency',sortable:true,width:60">${_(u"currency")}</th>
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
            <div class="button-group minor-group">
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/commissions/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/commissions/copy',property:'with_row'
                    ">
                    ${_(u"Copy")}</a>
                <a href="#" class="button easyui-linkbutton _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/commissions/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


<%def name="commission_list_details(commissions)">
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'services')}
        </div>
        <div class="dp85">
            <div class="dp100">
                <div class="b dp40">${_(u'service')}</div>
                <div class="b dp20">${_(u'percentage')}</div>
                <div class="b dp20">${_(u'price')}</div>
                <div class="b dp20">${_(u'currency')}</div>
            </div>
            % for commission in commissions:
            <div class="dp100">
                <div class="dp40">
                    ${commission.service.name}
                </div>
                <div class="dp20">
                    % if commission.percentage:
                        ${h.common.format_decimal(commission.percentage)}
                    % else:
                        &nbsp;
                    % endif
                </div>
                <div class="dp20">
                    % if commission.price:
                        ${h.common.format_decimal(commission.price)}
                    % else:
                        &nbsp;
                    % endif
                </div>
                <div class="dp20">
                    % if commission.currency:
                        ${commission.currency.iso_code}
                    % else:
                        &nbsp;
                    % endif
                </div>
            </div>
            % endfor
        </div>
    </div>
</%def>
