<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
%>
<div class="easyui-panel"
    data-options="
        height: 300,
        border:false,
        iconCls:'fa fa-globe',
        tools:'#${_t_id}'
    ">
    <div class="dp100 mb05 mt05">
        <span class="fa fa-globe ml05"></span>
        <span class="fs110 ml05 b mr05">
            ${_(u'Countries popularity')}
        </span>
    </div>
    <div id="map-${_id}" style="width:470px;height:262px;"></div>
    <script>
        function reload_map_${_id}(period){
            $.post(
                '${request.resource_url(_context, 'list')}',
                {'sort': 'iso_code', 'period': period},
                function(data){
                    $('#map-${_id}').vectorMap({
                        map: 'world_mill',
                        backgroundColor: 'transparent',
                        regionStyle: {
                          initial: {
                            fill: '#DCDCDC'
                          }
                        },
                        series: {
                          regions: [{
                            values: data,
                            scale: [
                                '#A9A9A9', '#808080', '#696969'
                            ],
                            normalizeFunction: 'polynomial'
                          }]
                        },
                        onRegionTipShow: function(e, el, code){
                            if(data[code] == undefined) 
                                el.html(el.html());
                            else
                                el.html(el.html()+' ('+data[code]+')');
                        }
                    });
                }
            );
        }
        reload_map_${_id}(365);
    </script>
</div>