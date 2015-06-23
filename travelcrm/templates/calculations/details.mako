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
</div>
