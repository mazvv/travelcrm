<table width="100%" class="grid-details">
    % if item.contacts:
	        <tr>
	            <td colspan="2" class="b">${_(u'contacts')}</td>
	        </tr>
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
<table width="100%" class="grid-details mt05">
    % if item.passports:
            <tr>
                <td colspan="2" class="b">${_(u'passports')}</td>
            </tr>
        % for passport in item.passports:
            <tr>
                <td class="tc" style="width: 50px;">
                    % if passport.passport_type == 'citizen':
                        ${_(u'citizen')}
                    % else:
                        ${_(u'foreign')}
                    % endif
                </td>
                <td>
                    ${passport.num}
                    % if passport.end_date:
                        ${_(u'expire date')} ${h.common.format_date(passport.end_date)}
                    % endif
                </td>
            </tr>
        % endfor
    % endif
</table>
