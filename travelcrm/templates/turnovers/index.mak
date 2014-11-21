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
        iconCls:'fa fa-pie-chart'
    "
    title="${_(u'Turnovers')}">
    <table class="easyui-datagrid"
        id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',pageNumber:1,
            view: detailview,
            onExpandRow: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                $('#' + row_id).load(
                    '/suppliers/details?id=' + row.id, 
                    function(){
                        $('#${_id}').datagrid('fixDetailRowHeight', index);
                        $('#${_id}').datagrid('fixRowHeight', index);
                    }
                );
            },
            detailFormatter: function(index, row){
                var row_id = 'row-${_id}-' + row.id;
                return '<div id=' + row_id + '></div>';
            },          
            onBeforeLoad: function(param){
                $.each($('#${_s_id}, #${_tb_id} .searchbar').find('input'), function(i, el){
                    param[$(el).attr('name')] = $(el).val();
                });
            }
        " width="100%">
        <thead>
            <th data-options="field:'id',sortable:true,width:50">${_(u"id")}</th>
            <th data-options="field:'name',sortable:true,width:200">${_(u"name")}</th>
            <th data-options="field:'sum_to',sortable:true,width:100">${_(u"sum to")}</th>
            <th data-options="field:'sum_from',sortable:true,width:100">${_(u"sum from")}</th>
			<th data-options="field:'balance',sortable:true,width:100">${_(u"balance")}</th>
            <th data-options="field:'currency',sortable:true,width:80">${_(u"currency")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container dl45">
        </div>
        <div class="ml45 tr">
            <div class="search">
                ${searchbar(_id, _s_id, prompt=_(u'Enter supplier name'))}
                <div class="advanced-search tl hidden" id = "${_s_id}">
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
                        ${h.fields.employees_combobox_field(request, None, 'modifier_id', show_toolbar=False)}
                    </div>
                    <div class="mt1">
                        <div class="button-group minor-group">
                            <a href="#" class="button _advanced_search_submit">${_(u"Find")}</a>
                            <a href="#" class="button" onclick="$(this).closest('.advanced-search').hide();">${_(u"Close")}</a>
                            <a href="#" class="button danger _advanced_search_clear">${_(u"Clear")}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
