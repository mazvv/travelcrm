<%namespace file="../common/resource.mako" import="resource_list_details"/>
<div class="dp100 item-details">
    % if item.descr:
        <div class="dp100">
            ${h.tags.literal(item.descr)}
        </div>
    % endif
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'name')}
        </div>
        <div class="dp85">
            ${item.name}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'resource')}
        </div>
        <div class="dp85">
            ${item.resource}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'resources count')}
        </div>
        <div class="dp85">
            ${item.resources.count()}
        </div>
    </div>
    <div class="dp100">
        <div class="dp15 b">
            ${_(u'settings')}
        </div>
        <div class="dp85">
            ${_(u'yes') if rt_ctx.allowed_settings else _(u'no')}
        </div>
    </div>
    <div class="dp100">
        ${resource_list_details(item.resource_obj)}
    </div>
</div>
