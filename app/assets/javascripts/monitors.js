//= require FusionCharts
//= require FusionCharts.jqueryplugin

$(document).ready(function(){


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

    if($('#data_source_10')!='undefined'){
        var chart = new FusionCharts( "/FusionCharts/Radar.swf",
            "chart_radar_01", "100%", 250, "0", "1" );
        var data_source = $('#data_source_10').val();
        chart.setXMLUrl(data_source);
        chart.render("chart-container-10");
    }

    if($('#data_source_0')!='undefined'){
        var chart = new FusionCharts( "/FusionCharts/AngularGauge.swf",
            "chart_angular_gauge_01", "100%", 250, "0", "1" );
        var data_source = $('#data_source_0').val();
        chart.setXMLUrl(data_source);
        chart.render("chart-container-0");
    }
});