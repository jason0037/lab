//= require FusionCharts
//= require FusionCharts.jqueryplugin

$(document).ready(function(){
    var realtimeChart = new FusionCharts( "/FusionCharts/RealTimeLineDY.swf", 
                                                  "camera_realtime_01", "100%", 300, "0", "1" );
    realtimeChart.setXMLUrl("/monitors/camera_data?equipment_code=000001");
    realtimeChart.render("camera-container-01");
});