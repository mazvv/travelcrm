<%namespace file="../persons/common.mako" import="person_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'type')}
        </div>
        <div class="dp85">
            ${item.type.title}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'period')}
        </div>
        <div class="dp85">
            <span class="fa fa-calendar-o mr05"></span>
            <span class="mr05">${_(u'from')}</span>
            ${h.common.format_date(item.start_date)}
            % if item.end_date:
                <span class="ml05 mr05">${_(u'to')}</span>
                ${h.common.format_date(item.end_date)}
            % endif
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'country')}
        </div>
        <div class="dp85">
            <span class="fa fa-globe mr05"></span>
            ${item.country.iso_code} (${item.country.name})
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
