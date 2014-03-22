<%def name="contacts_selector(name='contact_id', values=[], can_edit=True)">
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
			url:'/contacts/list',border:false,
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
			<th align="center" data-options="field:'contact_type',width:20,formatter:function(value){return format_contact_type(value);}"></th>
			<th data-options="field:'contact',sortable:true,width:200">${_(u"contact")}</th>
		</thead>
	</table>
	<div id="${_storage_id}">
        % for contact in values:
            ${h.tags.hidden(name, contact)}
        % endfor
	</div>
	% if can_edit:
	<div class="datagrid-toolbar" id="${_tb_id}">
		<div class="actions button-container">
			<div style="display: inline-block;padding-top:2px;">
				<%
					f_id = h.common.gen_id()
				%>
				${h.fields.contacts_combobox_field(request, None, f_id, id=f_id)}
			</div>
			<div class="button-group minor-group">
				<a href="#" class="button" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
				<a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
			</div>
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
            url:'/licences/list',border:false,
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
            <th data-options="field:'licence_num',sortable:true,width:200">${_(u"licence num")}</th>
            <th data-options="field:'date_from',sortable:true,width:120">${_(u"date from")}</th>
            <th data-options="field:'date_to',sortable:true,width:120">${_(u"date to")}</th>
        </thead>
    </table>
    <div id="${_storage_id}">
        % for licence in values:
            ${h.tags.hidden(name, licence)}
        % endfor
    </div>
    % if can_edit:
    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <div style="display: inline-block;padding-top:2px;">
                <%
                    f_id = h.common.gen_id()
                %>
                ${h.fields.licences_combobox_field(request, None, f_id, id=f_id)}
            </div>
            <div class="button-group minor-group">
                <a href="#" class="button" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>


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
            <div class="button-group minor-group">
                <a href="#" class="button" onclick="add_${_func_id}('${f_id}');">${_(u"Add")}</a>
                <a href="#" class="button danger" onclick="delete_${_func_id}('${_id}');">${_(u"Delete")}</a>
            </div>
        </div>
    </div>
    % endif
</%def>