<div class="dp100">
    <div class="dp25 b">${_(u'title')}</div>
    <div class="dp75">${item.title}</div>
</div>

% if item.descr:
<div class="dp100">
    ${h.tags.literal(item.descr)}
</div>
% endif

<div class="dp100 mt1">
    <div class="dp25 b">${_(u'maintainer')}</div>
    <div class="dp75">${item.resource.maintainer.name}</div>
</div>

<div class="dp100">
    <div class="dp25 b">${_(u'terms')}</div>
    <div class="dp75">
        % if item.reminder:
            <span class="fa fa-bell-o mr05 easyui-tooltip" title="${_(u'notification time')}"></span>
            ${h.common.format_datetime(item.reminder_datetime)}
            <span class="fa fa-long-arrow-right"></span>
        % endif
        <span class="fa fa-clock-o mr05 easyui-tooltip" title="${_(u'deadline')}"></span>${h.common.format_datetime(item.deadline)}
    </div>
</div>

% if task_resource:
<div class="dp100">
    <div class="dp25 b">${_(u'resource')}</div>
    <div class="dp75">
        <a href="javascript:void(0)" class="easyui-tooltip tc" title="${_(u'show resource')}" onclick="action(this);" 
            data-options="action:'dialog_open',url:'${request.resource_url(task_resource, 'view', query={'rid': item.task_resource.id})}'">
            ${item.task_resource.resource_type.humanize}
        </a>
        <span class="b">(id=${item.task_resource.id})</span>
    </div>
</div>
% endif
