//= require FusionCharts
//= require FusionCharts.jqueryplugin

$(document).ready(function(){

    var realtimeChart = new FusionCharts( "/FusionCharts/RealTimeLineDY.swf", 
                                                  "chart_realtime_01", "100%", 250, "0", "1" );
    //realtimeChart.setXMLUrl("/monitors/camera_data?equipment_code=000001");
    for( var i=1;i++;i<=4){
        if($('#data_source_'+i))
        var data_source = $('#data_source_'+i).val();
        realtimeChart.setXMLUrl(data_source);
        realtimeChart.render("chart-container-"+i);
    }
});