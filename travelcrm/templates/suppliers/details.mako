<%namespace file="../bpersons/common.mako" import="bperson_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    % if item.bpersons:
        <div class="dp100">
            <div class="dp15 b">
                ${_(u'contacts')}
            </div>
            <div class="dp85">
                % for bperson in item.bpersons:
                    <div>
                        ${bperson_list_details(bperson)}
                    </div>
                % endfor
            </div>
        </div>
    % endif
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
