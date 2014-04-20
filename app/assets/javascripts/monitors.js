//= require FusionCharts
//= require FusionCharts.jqueryplugin

$(document).ready(function(){

    var realtimeChart = new FusionCharts( "/FusionCharts/RealTimeLineDY.swf", 
                                                  "chart_realtime_01", "100%", 250, "0", "1" );
    //realtimeChart.setXMLUrl("/monitors/camera_data?equipment_code=000001");
    var data_source = $('#data_source').val();//document.getElementById('data_source').value; //

    realtimeChart.setXMLUrl(data_source);
    realtimeChart.render("chart-container-01");
});