<%namespace file="../common/context_info.mako" import="context_info"/>
<%
    _id = h.common.gen_id()
    _t_id = "t-%s" % _id
%>
<div class="easyui-panel"
    data-options="
        height: 300,
        border:false,
        iconCls:'fa fa-bar-chart',
        tools:'#${_t_id}'
    ">
    <div class="dp100 mb05 mt05">
        <span class="fa fa-bar-chart ml05"></span>
        <span class="fs110 ml05 b mr05">
            ${_(u'Orders count dynamics for last week')}
        </span>
    </div>
    <canvas id="chart-${_id}" width="470" height="262"></canvas>
    <script type="text/javascript">
        function reload_chart_${_id}(period){
            $.post(
                '${request.resource_url(_context, 'list')}',
                {'sort': 'date', 'period': period},
                function(data){
                    var ctx = $("#chart-${_id}").get(0).getContext("2d");
                    var line_chart = new Chart(ctx).Line(
                        data, {
                            scaleFontSize: 10,
                            tooltipFontSize: 10,
                            tooltipFillColor: "#fafafa",
                            tooltipFontColor: "#555",
                        }
                    );
                }
            );
        }
        reload_chart_${_id}(7);
    </script>
</div>