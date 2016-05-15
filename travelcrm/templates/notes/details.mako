% if item.descr:
<div class="dp100">
    ${h.tags.literal(item.descr)}
</div>
% endif

% if item.resource.maintainer:
<div class="dp100">
    <div class="dp25 b">${_(u'author')}</div>
    <div class="dp75">${item.resource.maintainer.name}</div>
</div>
% endif

% if note_resource:
<div class="dp100">
    <div class="dp25 b">${_(u'resource')}</div>
    <div class="dp75">
        <a href="javascript:void(0)" class="easyui-tooltip tc" title="${_(u'show resource')}" onclick="action(this);" 
            data-options="action:'dialog_open',url:'${request.resource_url(note_resource, 'view', query={'rid': item.note_resource.id})}'">
            ${item.note_resource.resource_type.humanize}
        </a>
        <span class="b">(id=${item.note_resource.id})</span>
    </div>
</div>
% endif
