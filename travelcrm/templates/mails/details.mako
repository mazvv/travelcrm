<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
