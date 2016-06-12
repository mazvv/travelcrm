<div class="dp100 item-details">
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'currency')}
        </div>
        <div class="dp85">
            ${item.order_item.currency.iso_code}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'final price')}
        </div>
        <div class="dp85">
            ${h.common.format_decimal(item.order_item.final_price)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'profit')}
        </div>
        <div class="dp85">
            ${h.common.format_decimal(item.order_item.final_price - item.price)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'contract')}
        </div>
        <div class="dp85">
            % if contract_resource:
                <a href="javascript:void(0)" class="easyui-tooltip tc" title="${_(u'show resource')}" onclick="action(this);" 
                    data-options="action:'dialog_open',url:'${request.resource_url(contract_resource, 'view', query={'rid': item.contract.resource.id})}'">
                    ${item.contract.resource.resource_type.humanize}
                </a>
                <span class="b">(id=${item.contract.resource.id})</span>
            % else:
                <span class="fa fa-warning lipstick"></span>
                <span class="m05">${_(u'contract does not exists')}</span>
            % endif
        </div>
    </div>
</div>
