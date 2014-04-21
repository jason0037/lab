//= require FusionCharts
//= require FusionCharts.jqueryplugin

$(document).ready(function(){

    var realtimeChart = new FusionCharts( "/FusionCharts/RealTimeLineDY.swf", 
                                                  "chart_realtime_01", "100%", 250, "0", "1" );
    //realtimeChart.setXMLUrl("/monitors/camera_data?equipment_code=000001");

    var tempString =' = new FusionCharts( "/FusionCharts/RealTimeLineDY.swf","chart_realtime_01", "100%", 250, "0", "1" )';

    for( var i=1;i<=4;i++){

        if($('#data_source_'+i)!='undefined'){
            var data_source = $('#data_source_'+i).val();
            eval('var rc'+i+tempString);
            eval('rc'+i+'.setXMLUrl(data_source)');
            eval('rc'+i+'.render("chart-container-'+i+'")');
        }
    }
});