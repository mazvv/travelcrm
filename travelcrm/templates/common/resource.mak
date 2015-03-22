<%def name="resource_list_details(resource)">
    <div class="pt05" style="border-top: 1px dashed #ccc;">
        <span class="b mr05">${_(u'resource stats')}:</span>
        ${_(u'tasks')} <span class="fa fa-long-arrow-right"></span>
        <span class="mr05">${resource.tasks.count()}</span>
        ${_(u'notes')} <span class="fa fa-long-arrow-right"></span>
        <span>${resource.notes.count()}</span>
    </div>
</%def>
