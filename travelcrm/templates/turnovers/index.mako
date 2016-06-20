<%namespace file="../common/search.mako" import="searchbar"/>
<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
    _tb_id = "tb-%s" % _id
    _s_id = "s-%s" % _id    
%>
<div class="easyui-panel unselectable"
    data-options="
        fit:true,
        border:false,
        iconCls:'fa fa-pie-chart',
        tools:'#${_t_id}'
    "
    title="${title}">
    ${context_info(_t_id, request)}
    <table class="easyui-treegrid" 
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            fit:true,pageSize:50,singleSelect:true,showFooter:true,
            sortName:'name',sortOrder:'asc', idField:'_id',treeField:'name',
            checkOnSelect:false,selectOnCheck:false,toolbar:'#${_tb_id}',
            onBeforeLoad: function(row, param){
                $.each($('#${_s_id}').find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            % if _context.has_permision('delete'):
            <th data-options="field:'_id',checkbox:true">${_(u"id")}</th>
            % endif
            <th data-options="field:'id',width:60">${_(u"id")}</th>
            <th data-options="field:'name',width:300">${_(u"name")}</th>
            <th data-options="field:'type',sortable:false,width:90,formatter:function(value, row){return account_item_type_formatter(value);}">${_(u"type")}</th>
            <th data-options="field:'revenue',sortable:false,width:120">${_(u"revenue")}</th>
            <th data-options="field:'expenses',sortable:false,width:120">${_(u"expenses")}</th>
            <th data-options="field:'balance',sortable:false,width:120">${_(u"balance")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl20">
            <script type="text/javascript">
            	function get_params_${_id}(use_sort_options){
            		var obj = $('#${_tb_id}');
            		var params = new Object();
            		$.each($('#${_s_id}').find('input'), function(i, el){
                        params[$(el).attr('name')] = $(el).val();
                    });
            		if(use_sort_options){
            			$('#${_id}').treegrid();
            			var dg_options = $('#${_id}').treegrid().treegrid('options');
            			params['sort'] = dg_options.sortName;
            			params['order'] = dg_options.sortOrder;
            		}
            		return $.param(params, true);
            	}
            </script>
            % if _context.has_permision('view'):
            <a href="#" class="button primary easyui-linkbutton _action" 
                data-options="container:'#${_id}',action:'blank_open',url:'${request.resource_url(_context, 'export')}',params_str:get_params_${_id}(true)">
                <span class="fa fa-print"></span>${_(u'Print')}
            </a>
            % endif
            <div class="button-group">
                <a href="#" class="button easyui-linkbutton" onclick="$('#${_id}').treegrid('expandAll');">
                    <span class="fa fa-plus-square-o"></span>
                </a>
                <a href="#" class="button easyui-linkbutton" onclick="$('#${_id}').treegrid('collapseAll')">
                    <span class="fa fa-minus-square-o"></span>
                </a>
            </div>
        </div>
        <div class="ml20 tl">
            <div>
                <div id="${_s_id}" class="dl50 mt02">
                    <span>
                        ${h.fields.date_field('date_from')}
                    </span>
                    <span class="mr05 ml05"> - </span>
                    <span class="mr1">
                        ${h.fields.date_field('date_to')}
                    </span>
                    ${h.fields.accounts_combogrid_field(
                        request,
                        'account_id',
                        None,
                        show_toolbar=False,
                        data_options="prompt:'%s'" % _(u'Select account')
                    )}
                </div>
                <div class="dl5 tr" style="width: 100px;">
                    <a href="#" class="button easyui-linkbutton" onclick="refresh_container('#${_id}');">
                        <span class="fa fa-search"></span>${_(u"Find")}
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
