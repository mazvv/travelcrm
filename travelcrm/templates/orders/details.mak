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
