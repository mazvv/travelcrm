<%namespace file="../persons/common.mak" import="person_list_details"/>
<%namespace file="../common/resource.mak" import="resource_list_details"/>
<div class="dp100 item-details">
    <div class="dp100 mb05">
        ${person_list_details(item.customer)}
    </div>
    <div class="dp100">
        <div class="dp50">
            <div class="mr05">
                % for wish_item in item.wishes_items:
                <div class="dp100 b">
                    ${wish_item.service.name}
                </div>
                <div class="dp100">
                    <%
                        prices = map(
                            lambda x: h.common.format_decimal(x),
                            filter(
                                None, [wish_item.price_from, wish_item.price_to]
                            )
                        )
                    %>
                    <span class="fa fa-money mr05 easyui-tooltip" title="${_(u'wish prices')}"></span>
                    % if prices:
                        ${' - '.join(prices)}
                        ${wish_item.currency and wish_item.currency.iso_code}
                    % else:
                        ${_(u'not set')}
                    % endif
                </div>
                <div class="mb05">
                    ${wish_item.descr}
                </div>
                % endfor
            </div>
        </div>
        <div class="dp50">
            <div class="ml05">
                % for offer_item in item.offers_items:
                <div class="dp100 b">
                    ${offer_item.service.name}
                </div>
                <div class="dp100">
                    <span class="fa fa-money mr05 easyui-tooltip" title="${_(u'offer prices')}"></span>
                    ${offer_item.price} ${offer_item.currency.iso_code}
                </div>
                <div class="mb05">
                    ${offer_item.descr}
                </div>
                % endfor
            </div>
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
