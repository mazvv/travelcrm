<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'advertise')}
        </div>
        <div class="dp85">
            ${item.advsource.name}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'services')}
        </div>
        <div class="dp85">
	    % for order_item in item.orders_items:
            <div class="dp100">
                <div class="dp75">
                    ${order_item.service.name}, ${order_item.supplier.name}
                    <span class="fa fa-money ml05 mr05"></span>
                    <em>
                        ${order_item.currency.iso_code} ${order_item.final_price}
                    </em>
                </div>
                <div class="dp25 tr">
                    <span class="mr1 status-label ${order_item.status.key}">
                        ${order_item.status.title}
                    </span>
                </div>
            </div>
	    % endfor
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
