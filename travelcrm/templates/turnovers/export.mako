<%inherit file="travelcrm:templates/_report.mako"/>
<h1>${_(u'Turnovers Report')}</h1>

<div class="main">
    <div class="dp100">
        % for row in rows:
            ${render_row(row)}
        % endfor
    </div>
</div>


<%def name="render_row(row, level=1)">
    <div class="dp100">
        <div class="dp40">
            <span style="margin-left: ${20 * level}px">
                ${row.get('name')}
            </span>
        </div>
        <div class="dp20">
            % if row.get('revenue'):
                ${row.get('revenue')}
            % endif
        </div>
        <div class="dp20">
            % if row.get('expenses'):
                ${row.get('expenses')}
            % endif
        </div>
        <div class="dp20">
            % if row.get('balance'):
                ${row.get('balance')}
            % endif
        </div>
    </div>
    % if row.get('children'):
        <%
            level += 1
        %>
        % for row in row.get('children'):
            ${render_row(row, level=level)}
        % endfor
    % endif
</%def>