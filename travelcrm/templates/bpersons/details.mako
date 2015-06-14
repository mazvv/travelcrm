<%namespace file="../contacts/common.mako" import="contact_list_details"/>
<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'contacts')}
        </div>
        <div class="dp85">
            % if item.has_active_contacts():
                ${contact_list_details(item.contacts)}
            % else:
                <span class="fa fa-exclamation mr05"></span>
                ${_(u'active contacts not exists')}
            % endif
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource)}
    </div>
</div>
