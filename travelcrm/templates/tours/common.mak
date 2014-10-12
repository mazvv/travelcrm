<%def name="tour_points_selector(name='tour_point_id', values=[], can_edit=True)">
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
    <script type="easyui-textbox/javascript">
        function formatter_${_func_id}(index, row){
            var html = '<table width="100%" class="grid-details">';
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'location')}</td>'
                + '<td>' + row.full_location_name + '</td>'
                + '</tr>';
            if(row.full_hotel_name){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'hotel')}</td>'
                    + '<td>' + row.full_hotel_name + '</td>'
                    + '</tr>';
            }
            if(row.accomodation_name){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'accomodation')}</td>'
                    + '<td>' + row.accomodation_name + '</td>'
                    + '</tr>';
            }
            if(row.roomcat_name){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'room category')}</td>'
                    + '<td>' + row.roomcat_name + '</td>'
                    + '</tr>';
            }
            if(row.foodcat_name){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'food category')}</td>'
                    + '<td>' + row.foodcat_name + '</td>'
                    + '</tr>';
            }
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'dates')}</td>'
                + '<td>' + row.point_start_date 
                + ' - ' + row.point_end_date + '</td>'
                + '</tr>';
            if(row.description){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'description')}</td>'
                    + '<td>' + row.description + '</td>'
                    + '</tr>';
            }
            html += '</table>';
            return html;
        }
    </script>
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'/tours/points',border:false,
            singleSelect:true,
            rownumbers:true,sortName:'point_start_date',sortOrder:'asc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            detailFormatter: function(index, row){
                return formatter_${_func_id}(index, row)
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
            <th data-options="field:'country_name',sortable:true,width:150">${_(u"country")}</th>
            <th data-options="field:'full_hotel_name',sortable:true,width:200">${_(u"hotel")}</th>
            <th data-options="field:'point_start_date',sortable:true,width:100">${_(u"start")}</th>
            <th data-options="field:'point_end_date',sortable:true,width:100">${_(u"end")}</th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for point in values:
            ${h.tags.hidden(name, point)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl35">
            <%
                f_id = h.common.gen_id()
            %>
            <div class="button-group minor-group">
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/tours/add_point'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/tours/edit_point',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
        <div class="ml35 tr" style="padding-top:5px;">
            ${h.common.error_container(name=name)}
        </div>
    </div>
    % endif
</%def>
