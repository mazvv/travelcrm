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
            ${_(u'customer')}
        </div>
        <div class="dp85">
            ${person_list_details(item.order.customer)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'account')}
        </div>
        <div class="dp85">
            ${item.account.name}, ${item.account.account_type.title}, ${item.account.currency.iso_code}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'services')}
        </div>
        <div class="dp85">
            <div class="dp100">
                <div class="b dp40">${_(u'service')}</div>
                <div class="b dp15">${_(u'price')}</div>
                <div class="b dp15">${_(u'discount')}</div>
                <div class="b dp15">${_(u'vat')}</div>
                <div class="b dp15">${_(u'final price')}</div>
            </div>
        % for invoice_item in item.invoices_items:
            <div class="dp100">
                <div class="dp40">
                    ${invoice_item.order_item.service.display_text}, ${invoice_item.order_item.supplier.name}
                </div>
                <div class="dp15">
                    ${invoice_item.price}
                </div>
                <div class="dp15">
                    ${invoice_item.discount}
                </div>
                <div class="dp15">
                    ${invoice_item.vat}
                </div>
                <div class="dp15">
                    ${invoice_item.final_price}
                </div>
            </div>
        % endfor
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
