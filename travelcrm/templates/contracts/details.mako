<%namespace file="../contacts/common.mako" import="commission_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'commissions')}
        </div>
        <div class="dp85">
            % if item.commissions:
                % for commission in item.commissions:
                    <div>
                        ${commission_list_details(commission)}
                    </div>
                % endfor
            % else:
                <span class="fa fa-exclamation mr05"></span>${_(u'not exists')}
            % endif
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
