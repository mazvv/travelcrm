<%def name="context_info(id, request)">
    <div id="${id}">
        <a href="javascript:void(0)" class="easyui-tooltip tc" title="${_(u'info')}" onclick="action(this);" 
            data-options="action:'dialog_open',url:'${request.resource_url(request.root, 'system_context_info', query={'rt': request.context.__name__})}'">
            <span class="fa fa-info-circle"></span>
        </a>
    </div>
</%def>
