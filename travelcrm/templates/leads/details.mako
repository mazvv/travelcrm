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
            % for lead_item in item.leads_items:
            <div>
                ${lead_item.service.name}
                <%
                    prices = map(
                        lambda x: h.common.format_decimal(x),
                        filter(
                            None, [lead_item.price_from, lead_item.price_to]
                        )
                    )
                %>
                <span class="fa fa-money ml05 mr05 easyui-tooltip" title="${_(u'lead prices')}"></span>
                % if prices:
                    ${' - '.join(prices)}
                    ${lead_item.currency and lead_item.currency.iso_code}
                % else:
                    ${_(u'not set')}
                % endif
            </div>
            <div>
                <em>${lead_item.descr}</em>
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
            % for lead_offer in item.leads_offers:
                <div class="dp100">
                    <div class="dp75">
                        ${lead_offer.service.name}, ${lead_offer.supplier.name}
                        <span class="fa fa-money ml05 mr05"></span>
                        ${h.common.format_decimal(lead_offer.price)} ${lead_offer.currency.iso_code}
                        <br/>
                        <em>${lead_offer.descr}</em>
                    </div>
                    <div class="dp25 tr">
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
