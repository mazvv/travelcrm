<%namespace file="../common/resource.mako" import="resource_list_details"/>
<%namespace file="../persons/common.mako" import="person_list_details"/>
<%namespace file="../addresses/common.mako" import="address_list_details"/>

<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'person')}
        </div>
        <div class="dp85">
            ${person_list_details(item)}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'gender')}
        </div>
        <div class="dp85">
            ${item.gender.title}
        </div>
    </div>
    % if item.birthday:
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'birthday')}
        </div>
        <div class="dp85">
            ${h.common.format_date(item.birthday)}
        </div>
    </div>
    % endif
    % if item.addresses:
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'addresses')}
        </div>
        <div class="dp85">
            % for address in item.addresses:
                <div>${address_list_details(address)}</div>
            % endfor
        </div>
    </div>
    % endif
    % if item.passports:
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'passports')}
        </div>
        <div class="dp85">
            <div class="dp100">
                <div class="b dp40">${_(u'passport num')}</div>
                <div class="b dp30">${_(u'type')}</div>
                <div class="b dp30">${_(u'end date')}</div>
            </div>
            % for passport in item.passports:
            <div class="dp100">
                <div class="dp40">
                    ${passport.num}
                </div>
                <div class="dp30">
                    ${passport.passport_type.title}
                </div>
                <div class="dp30">
                    ${h.common.format_date(passport.end_date)}
                </div>
            </div>
            % endfor
        </div>
    </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'subscriptions')}
        </div>
        <div class="dp85">
            <div class="dp100">
                <div class="dp30">${_(u'email subscription')}</div>
                <div class="dp70">
                    <span class="fa fa-toggle-${'on' if item.email_subscription else 'off'}"></span>
                </div>
            </div>
            <div class="dp100">
                <div class="dp30">${_(u'sms subscription')}</div>
                <div class="dp70">
                    <span class="fa fa-toggle-${'on' if item.sms_subscription else 'off'}"></span>
                </div>
            </div>
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
