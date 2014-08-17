<table width="100%" class="grid-details">
    % if item.bpersons:
        % for bperson in item.bpersons:
            ${contacts(bperson)}
        % endfor
    % endif
</table>

<%def name="contacts(bperson)">
    % if bperson.contacts:
        <tr>
            <td class="b" colspan="2">
                ${_(u'business person')}
            </td>
        </tr>
        <tr>
            <td colspan="2">
                ${bperson.name}
            </td>
        </tr>
        % for contact in bperson.contacts:
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
</%def>
