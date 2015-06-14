<%namespace file="../persons/common.mako" import="person_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'dates')}
        </div>
        <div class="dp85">
            ${h.common.format_date(item.start_date)}
            <span class="pl05 pr05">-</span>
            ${h.common.format_date(item.end_date)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'route')}
        </div>
        <div class="dp85">
            <span class="fa fa-long-arrow-right mr05""></span>
            <% 
                data = [
                    item.start_location.full_location_name,
                    item.start_transport.name,
                    item.start_additional_info,
                ]
                data = filter(None, data)
            %>
            ${', '.join(data)}
            <br/>
            <span class="fa fa-long-arrow-left mr05""></span>
            <% 
                data = [
                    item.end_location.full_location_name,
                    item.end_transport.name,
                    item.end_additional_info,
                ]
                data = filter(None, data)
            %>
            ${', '.join(data)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'location')}
        </div>
        <div class="dp85">
            <span class="fa fa-globe mr05""></span>
            ${item.hotel.location.region.country.iso_code} (${item.hotel.location.region.country.name})<br/>
            ${item.hotel.location.full_location_name}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'hotel')}
        </div>
        <div class="dp85">
            <%
                data = [
                    ' '.join([item.hotel.name, item.hotel.hotelcat.name]),
                    item.roomcat and item.roomcat.name,
                    item.foodcat and item.foodcat.name,
                    item.accomodation and item.accomodation.name,
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
