<%namespace file="../common/context_info.mako" import="context_info"/>
<%namespace file="../common/search.mako" import="searchbar"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _t_id = "t-%s" % _id
%>
<div class="dl60 easyui-dialog"
    data-options="
        border:false,
        height:400,
        modal:true,
        iconCls:'fa fa-table',
        tools:'#${_t_id}'
    "
    title="${title} | ${position.name}">
    ${context_info(_t_id, request)}
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
                $.each($('#${_tb_id} .searchbar').find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
                param.position_id = ${position.id};
            }
        " width="100%">
        <thead>
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'rt_humanize',sortable:true,width:150">${_(u"resource type")}</th>
            <th data-options="field:'permisions',width:200">permissions</th>
            <th data-options="field:'structure_path',sortable:true,width:200,formatter:function(value,row,index){return (value)?value.join(' &rarr; '):'';}">${_(u"structure")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl25">
            <div class="button-group">
                % if _context.has_permision('edit'):
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit', query=[('position_id', position.id)])}'">
                    <span class="fa fa-pencil"></span>${_(u'Edit Permissions')}
                </a>
                <a href="#" class="button easyui-linkbutton _action"
                    data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'copy', query=[('position_id', position.id)])}'">
                    <span class="fa fa-copy"></span>${_(u'Copy From ...')}
                </a>
                % endif
            </div>
        </div>
        <div class="ml25 tr">
            <div class="search">
                ${searchbar(_id, prompt=_(u'Enter resource type name'))}
            </div>
        </div>
    </div>
</div>
