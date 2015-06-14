% if item.descr:
<div class="dp100">
    ${item.descr}
</div>
% endif

<div class="dp100">
    <div class="dp25 b">${_(u'created')}</div>
    <div class="dp75">
        <span class="fa fa-clock-o mr05"></span>${h.common.format_datetime(item.created)}
    </div>
</div>

% if notification_resource:
<div class="dp100">
    <div class="dp25 b">${_(u'resource')}</div>
    <div class="dp75">
        <a href="javascript:void(0)" class="easyui-tooltip tc" title="${_(u'show resource')}" onclick="action(this);" 
            data-options="action:'dialog_open',url:'${request.resource_url(notification_resource, 'view', query={'rid': item.notification_resource.id})}'">
            ${item.notification_resource.resource_type.humanize}
        </a>
        <span class="b">(id=${item.notification_resource.id})</span>
    </div>
</div>
% endif
