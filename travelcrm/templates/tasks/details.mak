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
        <td>${h.common.format_datetime(item.deadline)}</td>
    </tr>
    % endif
    % if item.reminder:
    <tr>
        <td width="25%" class="b">${_(u'reminder')}</td>
        <td>${h.common.format_datetime(item.reminder)}</td>
    </tr>
    % endif
    <tr>
    	<td width="25%" class="b">${_(u'status')}</td>
        <td>
            <span class="task-status ${'task-closed' if item.closed else 'task-open'}">
                ${_('closed') if item.closed else _('open')}
            </span>
        </td>
    </tr>
    % if item.descr:
    <tr>
        <td colspan="2">
            ${h.tags.literal(item.descr)}
        </td>
    </tr>
    % endif
</table>
