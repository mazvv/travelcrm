<%
    _id = h.common.gen_id()
%>
% if item.descr:
<div class="dp100 pb05 mb05" style="border-bottom: 1px dashed #ccc;">
    ${h.tags.literal(item.descr)}
</div>
% endif

% if item.employee:
<div class="dp100">
    <div class="dp25 b">${_(u'performer')}</div>
    <div class="dp75">${item.employee.name}</div>
</div>
% endif

<div class="dp100">
    <div class="dp25 b">${_(u'terms')}</div>
    <div class="dp75">
        % if item.reminder:
            <span class="fa fa-bell-o mr05"></span>${h.common.format_datetime(item.reminder)}
            <span class="fa fa-long-arrow-right"></span>
        % endif
        <span class="fa fa-clock-o mr05"></span>${h.common.format_datetime(item.deadline)}
    </div>
</div>

% if item.task_resource:
<div class="dp100">
    <div class="dp25 b">${_(u'resource')}</div>
    <div class="dp75">
        ${item.task_resource.resource_type.humanize} (id=${item.task_resource.id})
    </div>
</div>
% endif
