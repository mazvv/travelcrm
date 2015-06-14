<%namespace file="../common/resource.mako" import="resource_list_details"/>
<%namespace file="../accounts/common.mako" import="account_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'subaccount from')}
        </div>
        <div class="dp85">
            % if item.cashflow.subaccount_from:
                ${item.cashflow.subaccount_from.name},
                ${account_list_details(item.cashflow.subaccount_from.account)}
            % else:
                <span class="fa fa-close"></span>
            % endif
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'subaccount to')}
        </div>
        <div class="dp85">
            % if item.cashflow.subaccount_to:
                ${item.cashflow.subaccount_to.name}
                ${account_list_details(item.cashflow.subaccount_to.account)}
            % else:
                <span class="fa fa-close"></span>
            % endif
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
