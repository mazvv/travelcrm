<%def name="searchbar(container, advanced_id=None, prompt=u'')">
    <%
        id = 'search' + container
    %>
    <div class="searchbar" style="padding-top: 2px;">
        ${h.tags.text("q", None, class_="easyui-textbox w25 searchbox", id=id, data_options="prompt:'%s'" % prompt)}
        <span class="field-actions">
            <span class="fa fa-search easyui-tooltip field-action _action" 
                  title="${_(u'search')}"
                  data-options="container: '#${container}', action: 'refresh'">
            </span>
            % if advanced_id:
            <script type="easyui-textbox/javascript">
                function show_advanced_${container}(e){
                    if($('#${advanced_id}').is(':visible'))
                        $('#${advanced_id}').css('z-index', 1);
                    else{
                        var zindex = get_higher_zindex();
                        $('#${advanced_id}').css('z-index', zindex + 1);
                    }
                    $('#${advanced_id}').toggle();
                }
                $('#${advanced_id} a._advanced_search_submit').on(
                    'click',
                    function(event){
                        event.preventDefault();
                        $('#${advanced_id}').toggle();
                        refresh_container('#${container}');                        
                    }
                );
                $('#${advanced_id} a._advanced_search_clear').on(
                    'click',
                    function(event){
                        event.preventDefault();
                        clear_inputs('#${advanced_id}');
                    }
                );

            </script>
            <span class="fa fa-search-plus easyui-tooltip field-action _action" 
                  title="${_(u'advanced search')}"
                  onclick="show_advanced_${container}();">
            </span>
            % endif
        </span>
        <script type="easyui-textbox/javascript">
        $('#${id}').textbox({
            inputEvents:$.extend({},$.fn.textbox.defaults.inputEvents,{
                keyup:function(e){
                    if(e.keyCode == 13) refresh_container('#${container}');
                }
            })
        })
        </script>
    </div>
</%def>
