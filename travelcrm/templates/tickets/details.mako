<%namespace file="../persons/common.mako" import="person_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'transport')}
        </div>
        <div class="dp85">
            ${item.transport.name}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'ticket class')}
        </div>
        <div class="dp85">
            ${item.ticket_class.name}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'route')}
        </div>
        <div class="dp85">
            <span class="fa fa-globe mr05""></span>
            ${item.start_location.region.country.iso_code} (${item.start_location.region.country.name})
            <span class="fa fa-long-arrow-right ml05 mr05""></span>
            ${item.end_location.region.country.iso_code} (${item.end_location.region.country.name})
            <br/>
            <span class="fa fa-long-arrow-right mr05""></span>
            <% 
                data = [
                    h.common.format_datetime(item.start_dt),
                    item.start_location.full_location_name,
                    item.start_additional_info,
                ]
                data = filter(None, data)
            %>
            ${', '.join(data)}
            <br/>
            <span class="fa fa-long-arrow-right mr05""></span>
            <% 
                data = [
                    h.common.format_datetime(item.start_dt),
                    item.end_location.full_location_name,
                    item.end_additional_info,
                ]
                data = filter(None, data)
            %>
            ${', '.join(data)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'members')}
        </div>
        <div class="dp85">
            % for person in item.order_item.persons:
            <div>
                ${person_list_details(person)}
            </div>
            % endfor
        </div>
    </div>
</div>
