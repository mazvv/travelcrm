<%def name="action_button(ctx, url, permision, class_, icon='', caption=u'action')">
    % if ctx.has_permision(permision):
	<a href="#" class="button${u' ' + class_ if class_ else ''}" data-url="${url}">
	    <span class="${icon}"></span> <span>${caption}</span>
	</a>
	% endif
</%def>
