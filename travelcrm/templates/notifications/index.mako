<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _t_id = "t-%s" % _id
%>
<div class="easyui-panel" data-options="fit:true,border:false">
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            sortName:'created',sortOrder:'asc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/notifications/details?id=' + row.id, 
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
                param.employee_id = ${h.common.get_auth_employee(request).id};
                $.each($('#${_tb_id} .searchbar').find('input'), function(i, el){
                    if(!is_undefined($(el).attr('name')))
                        param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            % if _context.has_permision('close'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'title',sortable:true,width:180">${_(u"title")}</th>
            <th data-options="field:'status',sortable:false,width:60,formatter:function(value, row){return status_formatter(value);}">${_(u"status")}</th>
            <th data-options="field:'created',sortable:true,width:110,styler:datagrid_resource_cell_styler"><strong>${_(u"created")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl20">
            % if _context.has_permision('close'):
            <a href="#" class="button easyui-linkbutton _action" 
                data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'close')}'">
                <span class="fa fa-times"></span>${_(u'Close')}
            </a>
            % endif
        </div>
        <div class="ml20 tr">
            <div class="searchbar" style="margin-top: 2px;">
                ${h.fields.notifications_statuses_combobox_field(
                    'status',
                    'new',
                    with_all=True,
                    data_options="width:100,onChange:function(o_v, n_v){$('#%s').datagrid('load');}" % _id
                )}
            </div>
        </div>
    </div>
</div>