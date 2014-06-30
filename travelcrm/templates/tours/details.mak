<table width="100%" class="grid-details">
    
    % if item.customer.contacts:
            <tr>
                <td class="b" colspan="2">
                    ${_(u'customer contacts')}
                </td>
            </tr>
        % for contact in item.customer.contacts:
		    <tr>
		        <td class="tc" style="width: 25px;">
		            ${h.common.contact_type_icon(contact.contact_type)}
		        </td>
		        <td>
		            ${contact.contact}
		        </td>
		    </tr>
        % endfor
    % endif
</table>
<table width="100%" class="grid-details">
    <tr>
        <td class="b" colspan="2">
            ${_(u'members')}
        </td>
    </tr>
    <tr>
        <td style="width: 140px;">
            ${_(u'adults')}
        </td>
        <td>
            ${item.adults}
        </td>
    </tr>
    <tr>
        <td style="width: 140px;">
            ${_(u'children')}
        </td>
        <td>
            ${item.children}
        </td>
    </tr>
</table>
<table width="100%" class="grid-details">
    <tr>
        <td class="b" colspan="2">
            ${_(u'route')}
        </td>
    </tr>
    <tr>
        <td style="width: 140px;">
            ${h.common.format_date(item.start_date)}
        </td>
        <td>
            ${item.start_location.full_location_name}
        </td>
    </tr>
    % for point in item.points:
        <tr>
            <td style="width: 140px;">
                ${h.common.format_date(point.start_date)} - ${h.common.format_date(point.end_date)}
            </td>
            <td>
                ${point.location.full_location_name}
            </td>
        </tr>
    % endfor
    <tr>
        <td style="width: 140px;">
            ${h.common.format_date(item.end_date)}
        </td>
        <td>
            ${item.end_location.full_location_name}
        </td>
    </tr>
</table>
