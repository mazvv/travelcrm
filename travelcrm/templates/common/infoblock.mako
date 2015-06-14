<%def name="infoblock(title, icon='fa-info-circle')">
    <div class="info-block mb05">
        <div class="tc dl2">
        	% if icon:
            <span class="fa ${icon}">&nbsp;</span>
            % endif
        </div>
        <div class="ml2">
            ${title}
        </div>
    </div>
</%def>
