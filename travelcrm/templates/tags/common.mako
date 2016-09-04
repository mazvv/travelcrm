<%def name="tags_selector(name='tag_id', values=[], can_edit=True)">
    <%
        _id = h.common.gen_id()
        _t_id = 't' + _id
    %>
    <script>
        function add_${_id}(row){
            var tags = $('#${_id}').find('[name=${name}]')
            var already_exists = false;
            $.each(tags, function(i, el){
                if($(el).val() == row.id){
                    already_exists = true;
                }
            });
            if(!already_exists){
                var container_id = '${_id}' + row.id
                var container = $('<span id="' + container_id + '" class="tag"/>')
                    .html(row.name);
                $('<input type="hidden" name="${name}"/>')
                    .val(row.id).appendTo(container);
                $('<i class="fa fa-close" onclick="$(\'#' + container_id + '\').remove()"/>')
                    .appendTo(container);
                container.appendTo('#${_id}');
            }
        }
    </script>

    <div id="${_id}" class="tags-container w20">
    % for tag in values:
        <span id="${_id}${tag.id}" class="tag">
            ${h.tags.hidden(name=name, value=tag.id)}
            ${tag.name}
            % if can_edit:
                <i class="fa fa-close" onclick="$('#${_id}${tag.id}').remove()"></i>
            % endif
        </span>
    % endfor
    </div>
    % if can_edit:
        ${h.fields.tags_combogrid_field(
            request, name + '_', id=_t_id, show_toolbar=can_edit,
            data_options="""
                onCheck:function(index, row){
                    add_%s(row);
                }
            """ % _id
        )}
        ${h.common.error_container(name=name)}
    % endif
</%def>
