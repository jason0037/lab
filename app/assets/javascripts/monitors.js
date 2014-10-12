//= require FusionCharts
//= require FusionCharts.jqueryplugin

$(document).ready(function(){
    for( var i=0;i<=9;i++){
        FusionCharts.setCurrentRenderer("javascript");
        if($('#chart-container-'+i)!='undefined'){
            var chartDiv =  $('#chart-container-'+i);
            var chart_type = chartDiv.attr("chart-type");
            var data_source = chartDiv.attr("data-source");
            var rc = new FusionCharts( "/FusionCharts/"+chart_type,"chart_new_"+i, "100%", "150", "0", "1" );
            rc.setXMLUrl(data_source);
            rc.render("chart-container-"+i);
            alert(FusionCharts.getCurrentRenderer());
        }
    }

    if($('#data_source_gantt')!='undefined'){
        var chart = new FusionCharts( "/FusionCharts/Gantt.swf",
            "chart_gantt_01", "100%", "300", "0", "1" );
        var data_source = $('#data_source_gantt').val();
        chart.setXMLUrl(data_source);
        chart.render("chart-container-gantt");
    }

    if($('#data_source_mscolumn2d')!='undefined'){
        var chart = new FusionCharts( "/FusionCharts/MSColumn2D.swf",
            "chart_mscolumn2d_01", "100%", "300", "0", "1" );
        var data_source = $('#data_source_mscolumn2d').val();
        chart.setXMLUrl(data_source);
        chart.render("chart-container-mscolumn2d");
    }

    if ($('#data_source_hbullet_1')!='undefined'){
        var tempString =' = new FusionCharts( "/FusionCharts/HBullet.swf","chart_hbullet_01", "100%","60","0","0")';
        for( var i=1;i<=5;i++){

            if($('#data_source_hbullet_'+i)!='undefined'){
                var data_source = $('#data_source_hbullet_'+i).val();
                eval('var rc'+i+tempString);
                eval('rc'+i+'.setXMLUrl(data_source)');
                eval('rc'+i+'.render("chart-container-hbullet-'+i+'")');
            }
        }
    }
});