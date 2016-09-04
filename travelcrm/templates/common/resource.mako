<%def name="resource_list_details(resource)">
    % if resource.maintainer:
    <div class="dp100">
        <div class="dp15">
            <span class="b">${_(u'maintainer')}</span>
        </div>
        <div class="dp85">
            ${resource.maintainer.name}
            % if h.employees.is_employee_currently_dismissed(resource.maintainer):
            <span class="fa fa-exclamation-circle ml1"></span> ${_(u'dissmissed')}
            % endif
        </div>
    </div>
        % if not h.employees.is_employee_currently_dismissed(resource.maintainer):
        <div class="dp100">
            <div class="dp15">
                <span class="b">${_(u'structure')}</span>
            </div>
            <div class="dp85">
                ${h.employees.get_employee_position(resource.maintainer).name}
                ${_(u'in')}
                ${h.tags.literal(' &rarr; '.join(
                    h.structures.get_structure_name_path(
                        h.employees.get_employee_structure(resource.maintainer)
                    )
                ))}
            </div>
        </div>
        % endif
    % endif
    % if resource.tags.count():
        <div class="dp100">
            <div class="dp15">
                <span class="b">${_(u'tags')}</span>
            </div>
            <div class="dp85">
                % for tag in resource.tags:
                    <span class="mr1">
                        <span class="fa fa-tag"></span> ${tag.name}
                    </span>
                % endfor
            </div>
        </div>
    % endif
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
