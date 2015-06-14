<%namespace file="../common/resource.mako" import="resource_list_details"/>
<%namespace file="../persons/common.mako" import="person_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'account item')}
        </div>
        <div class="dp85">
            ${item.account_item.name}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'invoice sum')}
        </div>
        <div class="dp85">
            ${h.common.format_currency(
                item.invoice.final_price,
                item.invoice.account.currency.iso_code
            )}
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
