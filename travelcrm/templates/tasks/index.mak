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
    ">
    <script type="text/javascript">
    function formatter_${_id}(index, row){
        var html = '<table width="100%" class="grid-details">';
        if(row.performer){
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'performer')}</td>'
                + '<td>' + row.performer + '</td>'
                + '</tr>';
        }
        if(row.deadline){
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'deadline')}</td>'
                + '<td>' + row.deadline + '</td>'
                + '</tr>';
        }
        if(row.reminder){
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'reminder')}</td>'
                + '<td>' + row.reminder + '</td>'
                + '</tr>';
        }
        if(row.priority){
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'priority')}</td>'
                + '<td>' + row.priority + '</td>'
                + '</tr>';
        }
        if(row.status){
            html += '<tr>'
                + '<td width="25%" class="b">${_(u'status')}</td>'
                + '<td>' + row.status + '</td>'
                + '</tr>';
        }
        if(row.closed){
            html += '<tr>'
                + '<td colspan="2"><span class="label green">${_('closed')}' 
                + '</span></td>'
                + '</tr>';
        }
        if(row.descr){
            html += '<tr>'
                + '<td colspan="2">' + row.descr + '</td>'
                + '</tr>';
        }
        html += '</table>';
        return html;
    }
    </script>
    <table class="easyui-datagrid"
    	id="${_id}"
        data-options="
            url:'${request.resource_url(_context, 'list')}',border:false,
            pagination:true,fit:true,pageSize:50,singleSelect:true,
            rownumbers:true,sortName:'id',sortOrder:'desc',
            pageList:[50,100,500],idField:'_id',checkOnSelect:false,
            selectOnCheck:false,toolbar:'#${_tb_id}',
            view: detailview,
            detailFormatter: function(index, row){
                return formatter_${_id}(index, row);
            },          
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
            <th data-options="field:'title',sortable:true,width:320">${_(u"title")}</th>
        </thead>
    </table>

    <div class="datagrid-toolbar" id="${_tb_id}">
        <div class="actions button-container">
            <div class="button-group minor-group">
	            % if _context.has_permision('add'):
	            <a id="btn" href="#" class="button primary _action" 
	                data-options="container:'#${_id}',action:'dialog_open',url:'${request.resource_url(_context, 'add')}'">
	                <span class="fa fa-plus"></span>${_(u'Add')}
	            </a>
	            % endif
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
    </div>
</div>
