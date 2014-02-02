<%def name="header()">
	<div class="dl20 logo">
	    <span class="logo-big">Travel<span class="lipstick">CRM</span></span>
	</div>
    % if hasattr(_context, 'is_logged') and _context.is_logged():
	<div class="dr10 tr">
	    <div class="logout">
	        <a href="/logout" class="dashed-link _dialog_open" data-url="/logout">${_(u"logout")}</a>
	        <span class="fa fa-sign-out"></span>
	    </div>
	</div>
	% endif
</%def>

<%def name="footer()">
	<div class="main tc">
	    Powered by <a href="http://www.travelcrm.org.ua" class="project-link">Travelcrm</a> | ver. ${h.common.get_package_version('travelcrm')}
	</div>
</%def>    
