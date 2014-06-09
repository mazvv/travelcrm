<%def name="bpersons_selector(name='bperson_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'name',sortable:true,width:200">${_(u"name")}</th>
            <th data-options="field:'position_name',sortable:true,width:200">${_(u"position name")}</th>
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
                ${h.fields.bpersons_combobox_field(request, None, f_id, id=f_id)}
            </div>
            <div class="button-group minor-group ml1">
                <a href="#" class="button" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                % if 'edit' in h.permisions.get_bpersons_permisions(request):
                <a href="#" class="button _action" 
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


<%def name="tour_points_selector(name='tour_point_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
    <script type="text/javascript">
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
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
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


<%def name="persons_selector(name='person_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
    <script type="text/javascript">
        function formatter_${_func_id}(index, row){
            var html = '<table width="100%" class="grid-details">';
            if(row.phone){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'phone')}</td>'
                    + '<td>' + row.phone + '</td>'
                    + '</tr>';
            }
            if(row.email){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'email')}</td>'
                    + '<td>' + row.email + '</td>'
                    + '</tr>';
            }
            if(row.skype){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'skype')}</td>'
                    + '<td>' + row.skype + '</td>'
                    + '</tr>';
            }
            if(row.customer_citizen_passport){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'citizen passport')}</td>'
                    + '<td>' + row.customer_citizen_passport + '</td>'
                    + '</tr>';
            }
            if(row.customer_foreign_passport){
                html += '<tr>'
                    + '<td width="25%" class="b">${_(u'foreign passport')}</td>'
                    + '<td>' + row.customer_foreign_passport + '</td>'
                    + '</tr>';
            }
            html += '</table>';
            return html;
        }
    </script>
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'/persons/list',border:false,
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'name',sortable:true,width:200">${_(u"name")}</th>
            <th data-options="field:'birthday',sortable:true,width:100">${_(u"birthday")}</th>
            <th data-options="field:'age',sortable:true,width:60">${_(u"age")}</th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for person in values:
            ${h.tags.hidden(name, person)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl40">
            <div style="display: inline-block;padding-top:2px;">
                <%
                    f_id = h.common.gen_id()
                %>
                ${h.fields.persons_combobox_field(request, None, f_id, id=f_id)}
            </div>
            <div class="button-group minor-group ml1">
                <a href="#" class="button" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                % if 'edit' in h.permisions.get_persons_permisions(request):
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/persons/edit',property:'with_row'
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


<%def name="licences_selector(name='licence_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
            url:'/licences/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'date_to',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(param){
                var response = $(this).data('response');
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'licence_num',sortable:true,width:140">${_(u"licence num")}</th>
            <th data-options="field:'date_from',sortable:true,width:80">${_(u"date from")}</th>
            <th data-options="field:'date_to',sortable:true,width:80">${_(u"date to")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
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
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/licences/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/licences/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


<%def name="contacts_selector(name='contact_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th align="center" data-options="field:'contact_type',width:20,formatter:function(value){return format_contact_type(value);}"></th>
            <th data-options="field:'contact',sortable:true,width:200">${_(u"contact")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
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
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/contacts/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button _action" 
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

<%def name="passports_selector(name='passport_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
            url:'/passports/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(param){
                var response = $(this).data('response');
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'passport_num',sortable:true,width:200">${_(u"passport num")}</th>
            <th data-options="field:'passport_type',sortable:true,width:100">${_(u"type")}</th>
            <th data-options="field:'end_date',width:80">${_(u"end date")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for id in values:
            ${h.tags.hidden(name, id)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <%
                f_id = h.common.gen_id()
            %>
            <div class="button-group minor-group">
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/passports/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/passports/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


<%def name="addresses_selector(name='address_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
            url:'/addresses/list',border:false,
            fit:true,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(param){
                var response = $(this).data('response');
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'full_location_name',sortable:true,width:200">${_(u"location")}</th>
            <th data-options="field:'zip_code',sortable:true,width:100">${_(u"zip code")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for id in values:
            ${h.tags.hidden(name, id)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <%
                f_id = h.common.gen_id()
            %>
            <div class="button-group minor-group">
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/addresses/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/addresses/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


<%def name="banks_details_selector(name='bank_detail_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
    <script type="text/javascript">
        function formatter_${_func_id}(index, row){
            var html = '<table width="100%" class="grid-details">';
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'beneficiary')}</td>'
                + '<td>' + row.beneficiary + '</td>'
                + '</tr>';
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'account')}</td>'
                + '<td>' + row.account + '</td>'
                + '</tr>';
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'swift code')}</td>'
                + '<td>' + row.swift_code + '</td>'
                + '</tr>';
            html += '</table>';
            return html;
        }
    </script>
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'/banks_details/list',border:false,
            singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            detailFormatter: function(index, row){
                return formatter_${_func_id}(index, row);
            },          
            onBeforeLoad: function(param){
                var response = $(this).data('response');
                if(response !== ''){
                    add_${_func_id}(response);
                    $(this).data('response', '');
                }
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'bank_name',sortable:true,width:150">${_(u"bank")}</th>
            <th data-options="field:'currency',sortable:true,width:100">${_(u"currency")}</th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for id in values:
            ${h.tags.hidden(name, id)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <div class="button-group minor-group">
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/banks_details/add'
                    ">
                    ${_(u"Add")}</a>
                <a href="#" class="button _action" 
                    data-options="
                        container:'#${_id}',action:'dialog_open',url:'/banks_details/edit',property:'with_row'
                    ">
                    ${_(u"Edit")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>

<%def name="accounts_selector(name='account_id', values=[], can_edit=True)">
    <%
        _func_id = h.common.gen_id()
        _id = h.common.gen_id()
        _storage_id = h.common.gen_id()
        _tb_id = "tb-%s" % _id
    %>
    % if can_edit:
    <script type="text/javascript">
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
    <script type="text/javascript">
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
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
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
                ${h.fields.accounts_combobox_field(request, None, f_id, id=f_id)}
            </div>
            <div class="button-group minor-group ml1">
                <a href="#" class="button" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                % if 'edit' in h.permisions.get_accounts_permisions(request):
                <a href="#" class="button _action" 
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