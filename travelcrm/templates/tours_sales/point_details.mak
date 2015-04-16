<table width="100%" class="grid-details">
    % if item.location:
    <tr>
        <td class="b" style="width: 140px;">
            ${_(u'location')}
        </td>
        <td>
            ${item.location.full_location_name}
        </td>
    </tr>
    % endif
    % if item.hotel:
    <tr>
        <td class="b" style="width: 140px;">
            ${_(u'hotel')}
        </td>
        <td>
            ${item.hotel.full_hotel_name}
        </td>
    </tr>
    % endif
    % if item.accomodation_type:
    <tr>
        <td class="b" style="width: 140px;">
            ${_(u'accomodation type')}
        </td>
        <td>
            ${item.accomodation_type.name}
        </td>
    </tr>
    % endif
    % if item.foodcat:
    <tr>
        <td class="b" style="width: 140px;">
            ${_(u'food category')}
        </td>
        <td>
            ${item.foodcat.name}
        </td>
    </tr>
    % endif
    % if item.roomcat:
    <tr>
        <td class="b" style="width: 140px;">
            ${_(u'room category')}
        </td>
        <td>
            ${item.roomcat.name}
        </td>
    </tr>
    % endif
    % if item.description:
    <tr>
        <td class="b" style="width: 140px;">
            ${_(u'description')}
        </td>
        <td>
            ${item.description}
        </td>
    </tr>
    % endif
</table>
