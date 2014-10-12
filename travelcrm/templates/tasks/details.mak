<%
    _id = h.common.gen_id()
%>
<table width="100%" class="grid-details">
    % if item.employee:
    <tr>
        <td width="25%" class="b">${_(u'performer')}</td>
        <td>${item.employee.name}</td>
    </tr>
    % endif
    % if item.deadline:
    <tr>
        <td width="25%" class="b">${_(u'deadline')}</td>
        <td>${h.common.format_date(item.deadline)}</td>
    </tr>
    % endif
    % if item.reminder:
    <tr>
        <td width="25%" class="b">${_(u'reminder')}</td>
        <td>${h.common.format_datetime(item.reminder)}</td>
    </tr>
    % endif
    % if item.priority:
    <tr>
        <td width="25%" class="b">
            ${_(u'priority')}
        </td>
        <td>
            <span class="task-priority ${item.priority}">
                ${item.priority}
            </span>
        </td>
    </tr>
    % endif
    % if item.status:
    <tr>
        <td width="25%" class="b">
            ${_(u'status')}
        </td>
        <td>
            <span class="task-status ${item.status}">
                ${item.status}
            </span>
        </td>
    </tr>
    % endif
    % if item.descr:
    <tr>
        <td colspan="2">
            ${h.tags.literal(item.descr)}
        </td>
    </tr>
    % endif
</table>
