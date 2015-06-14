<%def name="resource_list_details(resource)">
    <div class="dp100">
        <div class="dp15">
            <span class="b">${_(u'resource stats')}</span>
        </div>
        <div class="dp85">
            ${_(u'tasks')} <span class="fa fa-long-arrow-right"></span>
            <span class="mr05">${resource.tasks.count()}</span>
            ${_(u'notes')} <span class="fa fa-long-arrow-right"></span>
            <span>${resource.notes.count()}</span>
        </div>
    </div>
</%def>
