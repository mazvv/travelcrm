<%namespace file="../common/search.mak" import="searchbar"/>
<%
    _id = h.common.gen_id()
    _tb_id = "tb-%s" % _id
    _s_id = "s-%s" % _id    
%>
<div class="easyui-panel unselectable"
    data-options="
    	fit:true,
    	border:false,
    	iconCls:'fa fa-table'
    "
    title="${_(u'Persons')}">
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
            }
        " width="100%">
        <thead>
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            <th data-options="field:'id',sortable:true,width:60">${_(u"id")}</th>
            <th data-options="field:'name',sortable:true,width:200">${_(u"name")}</th>
            <th data-options="field:'status',width:50,formatter:function(value,row,index){return datagrid_resource_status_format(value);},styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"status")}</strong></th>
            <th data-options="field:'modifydt',sortable:true,width:120,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"updated")}</strong></th>
            <th data-options="field:'modifier',width:100,styler:function(){return datagrid_resource_cell_styler();}"><strong>${_(u"modifier")}</strong></th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl45">
            % if _context.has_permision('add'):
            <a id="btn" href="#" class="button primary _action" 
                data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'add')}'">
                <span class="fa fa-plus"></span>${_(u'Add New')}
            </a>
            % endif
            <div class="button-group">
                % if _context.has_permision('edit'):
                <a id="btn" href="#" class="button _action"
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_row',url:'${request.resource_url(_context, 'edit')}'">
                    <span class="fa fa-pencil"></span>${_(u'Edit')}
                </a>
                % endif
                % if _context.has_permision('delete'):
                <a id="btn" href="#" class="button danger _action" 
                    data-options="container:'#${_id}',action:'dialog_open',property:'with_rows',url:'${request.resource_url(_context, 'delete')}'">
                    <span class="fa fa-times"></span>${_(u'Delete')}
                </a>
                % endif
            </div>
        </div>
        <div class="ml45 tr">
			${searchbar(_id, _s_id, advanced_search)}
        </div>
    </div>
</div>


<%def name="advanced_search(id)">
    <div class="advanced-search tl" id = "${id}">
        <div>
            ${h.tags.title(_(u"updated"))}
        </div>
        <div>
            ${h.fields.date_field(None, "updated_from")}
            <span class="p1">-</span>
            ${h.fields.date_field(None, "updated_to")}
        </div>
        <div class="mt05">
            ${h.tags.title(_(u"modifier"))}
        </div>
        <div>
            ${h.fields.employees_combobox_field(request, None, 'modifier_id')}
        </div>
        <div class="mt05">
            ${h.tags.title(_(u"status"))}
        </div>
        <div>
            ${h.fields.status_field(None)}
        </div>
        <div class="ml20 tr button-group minor-group mt1">
            <a href="#" class="button _advanced_search_submit">${_(u"Find")}</a>
            <a href="#" class="button danger _advanced_search_clear">${_(u"Clear")}</a>
        </div>
    </div>
</%def>
