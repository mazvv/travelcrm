<table width="100%" class="grid-details">
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'service name')}
        </td>
        <td>
            ${item.service_item.service.name}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'supplier')}
        </td>
        <td>
            ${item.service_item.supplier.name}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'price')}
        </td>
        <td>
            ${item.service_item.currency.iso_code} ${item.service_item.price}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'base price')}
        </td>
        <td>
            ${h.common.get_base_currency()} ${item.service_item.base_price}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'supplier price')}
        </td>
        <td>
            ${item.currency.iso_code} ${item.price}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'supplier base price')}
        </td>
        <td>
            ${h.common.get_base_currency()} ${item.base_price}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'profit')}
        </td>
        <td>
            ${h.common.get_base_currency()}
            ${item.service_item.base_price - item.base_price}
        </td>
    </tr>
    <tr>
        <td class="b" style="width: 140px;" valign="top">
            ${_(u'person')}
        </td>
        <td>
            ${item.service_item.person.name}
		    % if item.service_item.person.contacts:
		    	<br/>
		        % for contact in item.service_item.person.contacts:
	                ${h.common.contact_type_icon(contact.contact_type)}
	                ${contact.contact}
	                <br/>
		        % endfor
		    % endif
        </td>
    </tr>
</table>
