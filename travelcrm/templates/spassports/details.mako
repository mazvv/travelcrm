<%namespace file="../persons/common.mako" import="person_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'photo done')}
        </div>
        <div class="dp85">
            % if item.photo_done:
                <span class="fa fa-check-square-o mr05"></span>
            % else:
                <span class="fa fa-square-o mr05"></span>
            % endif
        </div>
    </div>
    % if item.docs_receive_date:
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'docs receive')}
        </div>
        <div class="dp85">
            <span class="fa fa-calendar-o mr05"></span>
            ${h.common.format_date(item.docs_receive_date)}
        </div>
    </div>
    % endif
    % if item.docs_transfer_date:
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'docs transfer')}
        </div>
        <div class="dp85">
            <span class="fa fa-calendar-o mr05"></span>
            ${h.common.format_date(item.docs_transfer_date)}
        </div>
    </div>
    % endif
    % if item.passport_receive_date:
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'passport receive')}
        </div>
        <div class="dp85">
            <span class="fa fa-calendar-o mr05"></span>
            ${h.common.format_date(item.passport_receive_date)}
        </div>
    </div>
    % endif
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
