<%namespace file="../common/search.mako" import="searchbar"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
%>
<div class="easyui-panel" data-options="fit:true,border:false">
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            sortName:'modifydt',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/notes/details?id=' + row.id, 
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
                $.each($('#${_tb_id} .searchbar').find('input'), function(i, el){
                    if(!is_undefined($(el).attr('name')))
                        param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'title',sortable:true,width:230">${_(u"title")}</th>
            <th data-options="field:'subscriber',sortable:false,width:20,styler:datagrid_resource_cell_styler,formatter:subscriber_cell_formatter"><span class="fa fa-thumb-tack"></span></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:datagrid_resource_cell_styler"><strong>${_(u"updated")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar no-height" id="${_tb_id}">
        <div class="actions button-container">
            <div class="button-group minor-group">
                % if _context.has_permision('add'):
                <a href="#" class="button primary easyui-linkbutton _action" 
                    data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'add')}'">
                    <span class="fa fa-plus"></span>${_(u'Add')}
                </a>
                % endif
                % if _context.has_permision('view'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'view')}'">
                    <span class="fa fa-circle-o"></span>${_(u'View')}
                </a>
                % endif
                % if _context.has_permision('edit'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit')}'">
                    <span class="fa fa-pencil"></span>${_(u'Edit')}
                </a>
                ##<a href="#" class="button easyui-linkbutton _action"
                ##    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'copy')}'">
                ##    <span class="fa fa-copy"></span>${_(u'Copy')}
                ##</a>
                % endif
                % if _context.has_permision('delete'):
                <a href="#" class="button danger easyui-linkbutton _action" 
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'delete')}'">
                    <span class="fa fa-times"></span>${_(u'Delete')}
                </a>
                % endif
            </div>
        </div>
        <hr class="dashed"></hr>
        <div class="dp100">
            <div class="dp5 b pt02">
                <span class="fa fa-arrow-right"></span>
            </div>
            <div class="searchbar dp95">
                ${h.fields.employees_combogrid_field(
                    request, 'maintainer_id',
                    value=h.common.get_auth_employee(request).id,
                    show_toolbar=False,
                    data_options="onChange:function(o_v, n_v){$('#%s').datagrid('load');}" % _id
                )}
            </div>
        </div>
        <div class="clear"></div>
    </div>
</div>
