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
            ${person_list_details(item.customer)}
        </div>
    </div>
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
            <div class="dp100">
                <div class="b dp50">${_(u'service')}</div>
                <div class="b dp20">${_(u'price')}</div>
                <div class="b dp15">${_(u'currency')}</div>
            </div>
            % for lead_item in item.leads_items:
            <div class="dp100">
                <div class="dp50">
                    ${lead_item.service.name}
                </div>
                <div class="dp20">
                    <%
                        prices = map(
                            lambda x: h.common.format_decimal(x),
                            filter(
                                None, [lead_item.price_from, lead_item.price_to]
                            )
                        )
                    %>
                    % if prices:
                        ${' - '.join(prices)}
                    % else:
                        &nbsp;
                    % endif
                </div>
                <div class="dp15">
                    % if lead_item.currency:
                        ${lead_item.currency and lead_item.currency.iso_code}
                    % else:
                        &nbsp;
                    % endif
                </div>
            </div>
            % endfor
        </div>
    </div>

    % if item.leads_offers.count():
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'offers')}
        </div>
        <div class="dp85">
            <div class="dp100">
                <div class="b dp35">${_(u'service')}</div>
                <div class="b dp15">${_(u'supplier')}</div>
                <div class="b dp20">${_(u'price')}</div>
                <div class="b dp15">${_(u'currency')}</div>
                <div class="b dp15">${_(u'status')}</div>
            </div>
            % for lead_offer in item.leads_offers:
            <div class="dp100">
                <div class="dp35">
                    ${lead_offer.service.name}
                </div>
                <div class="dp15">
                    ${lead_offer.supplier.name}
                </div>
                <div class="dp20">
                    ${h.common.format_decimal(lead_offer.price)}
                </div>
                <div class="dp15">
                    ${lead_offer.currency.iso_code}
                </div>
                <div class="dp15">
                    <span class="mr1 status-label ${lead_offer.status.key}">
                        ${lead_offer.status.title}
                    </span>
                </div>
            </div>
            % endfor
        </div>
    </div>
    % endif

    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
