<%namespace file="../common/search.mak" import="searchbar"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
%>
<div class="dl60 easyui-dialog"
    data-options="
        border:false,
        height:400,
        modal:true,
        iconCls:'fa fa-table'
    "
    title="${_(u'Position Permissions')} | ${position.name}">
    <table class="easyui-datagrid"
    	id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(param){
                var dg = $(this);
                var searchbar = $('#${_tb_id}').find('.searchbar');
                $.each(searchbar.find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
                param.position_id = ${position.id};
            }
        " width="100%">
        <thead>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'rt_humanize',sortable:true,width:150">${_(u"resource type")}</th>
            <th data-options="field:'permisions',width:200">permissions</th>
            <th data-options="field:'structure_id',width:200,formatter:function(value,row,index){if(row.scope_type == 'all') return row.scope_type; return value;}">${_(u"structure")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl20">
            % if _context.has_permision('edit'):
            <a id="btn" href="#" class="button _action"
                data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit', query=[('position_id', position.id)])}'">
                <span class="fa fa-pencil"></span>${_(u'Edit Permissions')}
            </a>
            % endif
        </div>
        <div class="ml20 tr">
            ${searchbar(_id)}
        </div>
    </div>
</div>
