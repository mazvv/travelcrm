<div class="dl60 easyui-dialog"
    title="${title}"
    data-options="
        modal:true,
        draggable:false,
        resizable:false,
        iconCls:'fa fa-pencil-square-o'
    ">
    ${h.tags.form(request.url, class_="_ajax", autocomplete="off")}
        <div class="easyui-tabs" data-options="border:false,height:400">
            <div title="${_(u'Services')}">
                <table class="easyui-datagrid"
                    data-options="
                        url:'${request.resource_url(_context, 'services_info', query={'id': id})}',border:false,
                        fit:true,singleSelect:true, rownumbers:true,showFooter:true
                    " width="100%">
                    <thead>
                        <th data-options="field:'name',width:200">${_(u"service")}</th>
                        <th data-options="field:'unit_price',width:100,formatter:function(value, row, index){return value?('${currency} ' + value):'';}">${_(u"unit price")}</th>
                        <th data-options="field:'cnt',width:50">${_(u"qty")}</th>
                        <th data-options="field:'price',width:100,formatter:function(value, row, index){return '${currency} ' + value;}">${_(u"sum")}</th>
                    </thead>
                </table>
            </div>               
            <div title="${_(u'Accounts Items')}">
                <table class="easyui-datagrid"
                    data-options="
                        url:'${request.resource_url(_context, 'accounts_items_info', query={'id': id})}',border:false,
                        fit:true,singleSelect:true, rownumbers:true,showFooter:true
                    " width="100%">
                    <thead>
                        <th data-options="field:'name',width:200">${_(u"account item")}</th>
                        <th data-options="field:'cnt',width:50">${_(u"qty")}</th>
                        <th data-options="field:'price',width:100,formatter:function(value, row, index){return '${currency} ' + value;}">${_(u"sum")}</th>
                    </thead>
                </table>
            </div>             
            <div title="${_(u'Payments')}">
                <table class="easyui-datagrid"
                    data-options="
                        url:'${request.resource_url(_context, 'payments_info', query={'id': id})}',border:false,
                        fit:true,singleSelect:true, rownumbers:true,showFooter:true
                    " width="100%">
                    <thead>
                        <th data-options="field:'date',width:100">${_(u"payment date")}</th>
                        <th data-options="field:'sum',width:100,formatter:function(value, row, index){return '${currency} ' + value;}">${_(u"sum")}</th>
                    </thead>
                </table>
            </div>             
            <div title="${_(u'Transfers')}">
                <table class="easyui-datagrid"
                    data-options="
                        url:'${request.resource_url(_context, 'transfers_info', query={'id': id})}',border:false,
                        fit:true,singleSelect:true, rownumbers:true,showFooter:true
                    " width="100%">
                    <thead>
                        <th data-options="field:'date',width:70">${_(u"date")}</th>
                        <th data-options="field:'from',width:180">${_(u"from")}</th>
                        <th data-options="field:'to',width:180">${_(u"to")}</th>
                        <th data-options="field:'account_item',width:150">${_(u"account item")}</th>
                        <th data-options="field:'sum',width:80,formatter:function(value, row, index){return '${currency} ' + value;}">${_(u"sum")}</th>
                    </thead>
                </table>
            </div>             
        </div>
        <div class="form-buttons">
            <div class="dl20 status-bar"></div>
            <div class="ml20 tr">
                ${h.common.reset('cancel', _(u"Cancel"), class_="button danger")}
            </div>
        </div>
    ${h.tags.end_form()}
</div>
