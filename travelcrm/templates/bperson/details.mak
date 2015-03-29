<table width="100%" class="grid-details">
    % if item.contacts:
        % for contact in item.contacts:
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
