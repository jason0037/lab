# encoding: utf-8
require 'pp'
require 'rufus-scheduler'

class MonitorsController < ApplicationController
  # GET /lab_cats
  # GET /lab_cats.json
  layout "blank"#,:except => [:show]
  def online

  end

  def general_behaviour

  end

  def interactive_study

  end

  def course_study

  end

  def index
    @lab_courses = LabCourse.limit(5).order("created_at DESC")
  end

  def comprehensive

  end

  def energy_consumption

  end

  def network

  end

  def mind_wave

  end

  def behaviour
    scheduler = Rufus::Scheduler.start_new(:thread_name => 'behaviour001')
    @logger ||= Logger.new("log/scheduler.log")
    puts Time.new
    j=0
    scheduler.every  '5s', :timeout => '1m' do
      j= j+1
      read_at = Time.now.strftime('%Y%m%d%H%M%S')
      res = Net::HTTP.get_response(URI.parse('http://180.173.14.8:23456/')).body.split("\r\n")

      res.each do |value|
        sql ="insert B000001_reading (point_id,read_at,saved_at,value,source) values('00000#{value[1,1]}'
          ,'#{read_at}','#{Time.now.strftime('%Y%m%d%H%M%S')}','#{value[2,5]}','#{value[0,1]}')"
        ActiveRecord::Base.connection.execute sql

      end
      if (j>100)
        scheduler.stop
      end
    end
  end

  class BData < LabData
   set_table_name "#{table_name}"
  end

  def energy_consumption_data
    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010101"

    cats_str = ''
    data_str = ''
    seriesname=''
    pyaxisname=''
    syaxisname=''
    select ="'' as read_at,value"

    if size!='small'
      select = "read_at,value"
      seriesname='实时能耗'
      pyaxisname="用电量(千瓦时)"
      syaxisname="温度(℃)"
    end
    datas = BData.select("#{select}").where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")
    datas.each do |data|
      cats_str += "<category label='#{data.read_at}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='#{seriesname}' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000'
canvasBgAlpha='100' divLineColor='008040' vDivLineColor='008040' divLineAlpha='100'
baseFontColor='00dd00' caption='能耗监测' dataStreamURL='' refreshInterval='900'
PYAxisName='#{pyaxisname}' SYAxisName='#{syaxisname}' SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1'
 setAdaptiveSYMin='1'  showRealTimeValue='0' realTimeValuePadding='10' showLabel='0'
labelDisplay='Rotate' slantLabels='1' labelStep='2' numDisplaySets='95' numVDivLines='47'
toolTipBgColor='000000' toolTipBorderColor='008040' baseFontSize='16' baseFont='微软雅黑'
showAlternateHGridColor='0' legendBgColor='000000' legendBorderColor='008040' legendShadow='0'>
<styles><definition><style name='MyFontStyle' type='font' size='24' bold='0'/></definition>
<application><apply toObject='Caption' styles='MyFontStyle' />
</application></styles>#{categorys}#{datasets}</chart>"
    render :text => charts
  end

  def mind_wave_data
    equipment_code = params[:equipment_code]
    point_id = params[:point_id]
    size = params[:size]
=begin
    if (point_id.blank?)
      point_id='000000'
    end
    case point_id
      when "000000"
        mind_wave_meaning="注意力"
        meaning_color="00dd00"
      when "000001"
        mind_wave_meaning="放松度"
        meaning_color="000093"
    end
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010001"
    datas = BData.where("point_id='#{point_id}' and read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str = ''
    read_at = ''
    datas.each do |data|
      if size!='small'
        read_at = data.read_at[8..14]
      end
      cats_str += "<category label='#{read_at}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='实时脑波' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='FFFFFF' bgAlpha='100'  canvasBorderThickness='1'
canvasBorderColor='008040' canvasBgColor='FFFFFF' canvasBgAlpha='100' divLineColor='008040'
vDivLineColor='008040' divLineAlpha='100' baseFontColor='#{meaning_color}' caption='#{mind_wave_meaning}监测'
dataStreamURL='' refreshInterval='900' PYAxisName='100%' SYAxisName='课堂测试成绩'
SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate'
slantLabels='1' labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='FFFFFF'
toolTipBorderColor='008040' baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0'
legendBgColor='FFFFFF' legendBorderColor='008040' legendShadow='0'><styles><definition>
<style name='MyFontStyle' type='font' size='20' bold='0'/></definition><application>
<apply toObject='Caption' styles='MyFontStyle' /></application></styles>#{categorys}#{datasets}</chart>"
=end

    axistitle1=''
    axistitle2=''
    axistitle3=''
    seriesname1=''
    seriesname2=''
    seriesname3=''
    seriesname4=''
    categories="<category label='' /><category label='' /><category label='' />
    <category label='' /><category label='' /><category label='' />
    <category label='' /><category label='' /><category label='' /><category label='' />"
      if size!='small'
        axistitle1='注意力-放松度'
        axistitle2='课堂测试成绩'
        axistitle3='Processes'
        seriesname1='注意力'
        seriesname2='放松度'
        seriesname3='课堂测验成绩'
        seriesname4='阿尔法波'
        categories="<category label='10:35' /><category label='10:37' /><category label='10:38' />
<category label='10:39' /><category label='10:40' /><category label='10:41' />
<category label='10:42' /><category label='10:43' /><category label='10:44' /><category label='10:45' />"
      end
charts="<chart palette='2' caption='脑波监测' subcaption='' xaxisname='Time' showvalues='0'
divlinealpha='100' numvdivlines='4' vdivlinealpha='0' showalternatevgridcolor='1' alternatevgridalpha='5'
canvaspadding='0' labeldisplay='ROTATE' >
<categories>#{categories}</categories>
<axis title='#{axistitle1}' titlepos='left' tickwidth='10' divlineisdashed='1' numbersuffix='%'>
<dataset seriesname='#{seriesname1}' linethickness='3' color='CC0000'>
<set value='16' /><set value='19' /><set value='16' /><set value='17' />
<set value='23' /><set value='23' /><set value='15' />
<set value='14' /><set value='19' /><set value='21' /></dataset>
<dataset seriesname='#{seriesname2}' linethickness='3' color='0372AB'>
<set value='12' /><set value='12' /><set value='9' /><set value='9' />
<set value='11' /><set value='13' /><set value='16' /><set value='14' />
<set value='16' /><set value='11' /></dataset></axis>
<axis title='#{axistitle2}' axisonleft='0' titlepos='right' numdivlines='4' tickwidth='10'
divlineisdashed='1' formatnumberscale='1' defaultnumberscale=' MB' numberscaleunit='GB' numberscalevalue='1024'>
<dataset seriesname='#{seriesname3}'>
<set value='96' /><set value='71' /><set value='36' /><set value='71' />
<set value='100' /><set value='89' /><set value='93' /><set value='93' />
<set value='57' /><set value='93' /></dataset></axis>
<axis title='#{axistitle3}' titlepos='RIGHT' axisonleft='0' numdivlines='5' tickwidth='10' divlineisdashed='1'>
<dataset seriesname='#{seriesname4}'>
<set value='543' /><set value='511' /><set value='536' /><set value='449' />
<set value='668' /><set value='588' /><set value='511' /><set value='536' />
<set value='449' /><set value='668' /></dataset></axis></chart>"
    render :text => charts

  end

  def network_data
    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010101"

    cats_str = ''
    data_str = ''
    select =" '' as read_at ,value"
    seriesname=''
    score=''
    pyaxisname=''
    if size!='small'
      select = "read_at,value"
      seriesname='实时网络'
      score="课堂测试成绩"
      pyaxisname="网速(比特/秒)"
    end
    datas = BData.select("#{select}").where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")
    datas.each do |data|

      cats_str += "<category label='#{data.read_at}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='#{seriesname}' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='00dd00'
caption='网络监测' dataStreamURL='' refreshInterval='900' PYAxisName='#{pyaxisname}'
 SYAxisName='#{score}' SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate' slantLabels='1'
labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='000000' toolTipBorderColor='008040'
baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0' legendBgColor='000000'
legendBorderColor='008040' legendShadow='0'><styles><definition><style name='MyFontStyle'
type='font' size='24' bold='0'/></definition><application><apply toObject='Caption' styles='MyFontStyle' />
</application></styles>#{categorys}#{datasets}</chart>"
    render :text => charts
  end

  def behaviour_data
    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140420010001"
    end_time = "20150101010101"

    cats_str = ''
    data_str = ''
    select =" '' as read_at,sum(value) as value"
    seriesname=''
    score=''
    pyaxisname=''
    if size!='small'
      select =" read_at,sum(value) as value "
      seriesname='实时体态'
      score="课堂测试成绩"
      pyaxisname="体态变化值"
    end
    datas = BData.select("#{select}").group("read_at").where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    datas.each do |data|
      cats_str += "<category label='#{data.read_at}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='#{seriesname}' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='FFFFFF' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='FFFFFF' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='#28004D'
caption='行为体态监测' dataStreamURL='' refreshInterval='900' PYAxisName='#{pyaxisname}'
SYAxisName='#{score}' SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate' slantLabels='1'
labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='FFFFFF' toolTipBorderColor='008040'
baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0' legendBgColor='FFFFFF'
legendBorderColor='008040' legendShadow='0'><styles><definition>
<style name='MyFontStyle' type='font' size='24' bold='0'/></definition>
<application><apply toObject='Caption' styles='MyFontStyle' /></application>
</styles>#{categorys}#{datasets}</chart>"
    render :text => charts
  end

  def dashboard_data

    charts = "<chart manageresize='1' origw='300' origh='300' bgcolor='FFFFFF' upperlimit='100' lowerlimit='0' basefontcolor='FFFFFF' majortmnumber='11' majortmcolor='FFFFFF' majortmheight='8' minortmnumber='5' minortmcolor='FFFFFF' minortmheight='3' tooltipbordercolor='FFFFFF' tooltipbgcolor='333333' gaugeouterradius='100' gaugestartangle='225' gaugeendangle='-45' placevaluesinside='1' gaugeinnerradius='80%' annrenderdelay='0' gaugefillmix='' pivotradius='10' showpivotborder='0' pivotfillmix='{CCCCCC},{333333}' pivotfillratio='50,50' showshadow='0' gaugeoriginx='150' gaugeoriginy='150' >
<colorrange>
<color minvalue='0' maxvalue='50' code='C1E1C1' alpha='40' />
<color minvalue='50' maxvalue='85' code='F6F164' alpha='40' />
<color minvalue='85' maxvalue='120' code='F70118' alpha='40' />
</colorrange>
<dials>
<dial value='65' bordercolor='FFFFFF' bgcolor='000000,CCCCCC,000000' borderalpha='0' basewidth='10' />
</dials>
<annotations>
<annotationgroup x='150' y='150' showbelow='1'>
<annotation type='circle' x='0' y='0' radius='145' fillcolor='CCCCCC,111111' fillpattern='linear' fillalpha='100,100' fillratio='50,50' fillangle='-45' />
<annotation type='circle' x='0' y='0' radius='120' fillcolor='111111,cccccc' fillpattern='linear' fillalpha='100,100' fillratio='50,50' fillangle='-45' />
<annotation type='circle' x='0' y='0' radius='110' color='666666' />
</annotationgroup>
</annotations>
</chart>"
    render :text => charts
  end

  def comprehensive_data

    charts = "<chart caption='综合分析' canvasborderalpha='0' radarborderalpha='50' radarborderthickness='1' radarfillcolor='FFFFFF' showlabels='1' drawanchors='0' ymaxvalue='10' showlimits='0' bgcolor='FFFFFF' legendborderalpha='0' >
<categories>
<category label='行为体态指数' />
<category label='注意力脑波指数' />
<category label='网速' />
<category label='课堂测试成绩' />
<category label='' />
<category label='' />
<category label='放松度脑波指数' />
</categories>
<dataset seriesname=' ' color='008ee4' alpha='40'>
<set value='8' />
<set value='9' />
<set value='9' />
<set value='8' />
<set value='7' />
<set value='9' />
<set value='8' />
</dataset>
<dataset seriesname=' ' color='6baa01' alpha='40'>
<set value='7' />
<set value='6' />
<set value='6' />
<set value='4' />
<set value='7' />
<set value='6' />
<set value='5' />
</dataset>
</chart>"
    render :text => charts
  end

  def general_behaviour_data

    charts = "<chart showtasknames='1' dateformat='dd/mm/yyyy' tooltextbgcolor='FFFFFF' tooltextbordercolor='333333' ganttlinecolor='99CC00' ganttlinealpha='20' basefontcolor='333333' gridbordercolor='99CC00' taskbarroundradius='4' showshadow='0' >
<categories bgcolor='333333' fontcolor='99cc00' isbold='1' fontsize='14'>
<category start='1/9/2013' end='31/12/2013' name='2013' />
<category start='1/1/2014' end='31/7/2014' name='2014' />
</categories>
<categories bgcolor='99cc00' bgalpha='40' fontcolor='333333' align='center' fontsize='10' isbold='1'>
<category start='1/9/2013' end='30/9/2013' name='Sep' />
<category start='1/10/2013' end='31/10/2013' name='Oct' />
<category start='1/11/2013' end='30/11/2013' name='Nov' />
<category start='1/12/2013' end='31/12/2013' name='Dec' />
<category start='1/1/2014' end='31/1/2014' name='Jan' />
<category start='1/2/2014' end='28/2/2014' name='Feb' />
<category start='1/3/2014' end='31/3/2014' name='March' />
<category start='1/4/2014' end='30/4/2014' name='Apr' />
<category start='1/5/2014' end='31/5/2014' name='May' />
<category start='1/6/2014' end='30/6/2014' name='June' />
<category start='1/7/2014' end='31/7/2014' name='July' />
</categories>
<processes positioningrid='right' align='center' headertext=' Leader  ' fontcolor='333333' fontsize='11' isbold='1' isanimated='1' bgcolor='99cc00' headerbgcolor='333333' headerfontcolor='99CC00' headerfontsize='16' bgalpha='40'>
<process name='性别' id='1' />
<process name='年龄' id='2' />
<process name='地域' id='3' />
<process name='学习时长' id='4' />
<process name='学习时段' id='5' />
<process name='学习终端' id='6' />
</processes>
<datatable showprocessname='1' fontcolor='333333' fontsize='11' isbold='1' headerfontcolor='000000' headerfontsize='11'>
<datacolumn headerbgcolor='333333' width='150' headerfontsize='16' headeralign='left' headerfontcolor='99cc00' bgcolor='99cc00' headertext='学习路径' align='left' bgalpha='65'>
<text label=' MANAGEMENT' />
<text label=' PRODUCT MANAGER' />
<text label=' CORE DEVELOPMENT' />
<text label=' Q & A / DOC.' />
<text label=' WEB TEAM' />
<text label=' MANAGEMENT' />
</datacolumn>
</datatable>
<tasks width='10'>
<task name='Survey' hovertext='Market Survey' processid='1' start='7/9/2013' end='10/10/2013' id='Srvy' color='99cc00' alpha='60' toppadding='19' />
<task name='Concept' hovertext='Develop Concept for Product' processid='1' start='25/10/2013' end='9/11/2013' id='Cpt1' color='99cc00' alpha='60' />
<task name='Concept' showlabel='0' hovertext='Develop Concept for Product' processid='2' start='25/10/2013' end='9/11/2013' id='Cpt2' color='99cc00' alpha='60' />
<task name='Design' hovertext='Preliminary Design' processid='2' start='12/11/2013' end='25/11/2013' id='Desn' color='99cc00' alpha='60' />
<task name='Product Development' processid='2' start='6/12/2013' end='2/3/2014' id='PD1' color='99cc00' alpha='60' />
<task name='Product Development' processid='3' start='6/12/2013' end='2/3/2014' id='PD2' color='99cc00' alpha='60' />
<task name='Doc Outline' hovertext='Documentation Outline' processid='2' start='6/4/2014' end='1/5/2014' id='DocOut' color='99cc00' alpha='60' />
<task name='Alpha' hovertext='Alpha Release' processid='4' start='15/3/2014' end='2/4/2014' id='alpha' color='99cc00' alpha='60' />
<task name='Beta' hovertext='Beta Release' processid='3' start='10/5/2014' end='2/6/2014' id='Beta' color='99cc00' alpha='60' />
<task name='Doc.' hovertext='Documentation' processid='4' start='12/5/2014' end='29/5/2014' id='Doc' color='99cc00' alpha='60' />
<task name='Website Design' hovertext='Website Design' processid='5' start='18/5/2014' end='22/6/2014' id='Web' color='99cc00' alpha='60' />
<task name='Release' hovertext='Product Release' processid='6' start='5/7/2014' end='29/7/2014' id='Rls' color='99cc00' alpha='60' />
<task name='Dvlp' hovertext='Development on Beta Feedback' processid='3' start='10/6/2014' end='1/7/2014' id='Dvlp' color='99cc00' alpha='60' />
<task name='QA' hovertext='QA Testing' processid='4' start='9/4/2014' end='22/4/2014' id='QA1' color='99cc00' alpha='60' />
<task name='QA2' hovertext='QA Testing-Phase 2' processid='4' start='25/6/2014' end='5/7/2014' id='QA2' color='99cc00' alpha='60' />
</tasks>
<connectors color='99cc00' thickness='2'>
<connector fromtaskid='Cpt1' totaskid='Cpt2' fromtaskconnectstart='1' />
<connector fromtaskid='PD1' totaskid='PD2' fromtaskconnectstart='1' />
<connector fromtaskid='PD1' totaskid='alpha' />
<connector fromtaskid='PD2' totaskid='alpha' />
<connector fromtaskid='DocOut' totaskid='Doc' />
<connector fromtaskid='QA1' totaskid='beta' />
<connector fromtaskid='Dvlp' totaskid='QA2' />
<connector fromtaskid='QA2' totaskid='Rls' />
</connectors>
<milestones>
<milestone date='29/7/2014' taskid='Rls' radius='10' color='333333' shape='Star' numsides='5' borderthickness='1' />
<milestone date='2/3/2014' taskid='PD1' radius='10' color='333333' shape='Star' numsides='5' borderthickness='1' />
<milestone date='2/3/2014' taskid='PD2' radius='10' color='333333' shape='Star' numsides='5' borderthickness='1' />
</milestones>
</chart>"
    render :text => charts
  end

  def interactive_study_data

    charts = "<chart caption='常用的交互方式' numberprefix='人次' plotgradientcolor='' bgcolor='FFFFFF'
showalternatehgridcolor='0' divlinecolor='CCCCCC' showvalues='0' showcanvasborder='0' canvasborderalpha='0'
canvasbordercolor='CCCCCC' canvasborderthickness='1' yaxismaxvalue='30000' captionpadding='30'
yaxisvaluespadding='15' legendshadow='0' legendborderalpha='0'
palettecolors='#f8bd19,#008ee4,#33bdda,#e44a00,#6baa01,#583e78' showplotborder='0' >
<categories>
<category label='Jan' /><category label='Feb' /><category label='Mar' /><category label='Apr' />
<category label='May' /><category label='Jun' /><category label='Jul' /><category label='Aug' />
<category label='Sep' /><category label='Oct' /><category label='Nov' /><category label='Dec' />
</categories>
<dataset seriesname='异步'>
<set value='22400' /><set value='24800' /><set value='21800' /><set value='21800' />
<set value='24600' /><set value='27600' /><set value='26800' /><set value='27700' />
<set value='23700' /><set value='25900' /><set value='26800' /><set value='24800' />
</dataset>
<dataset seriesname='同步'>
<set value='10000' /><set value='11500' /><set value='12500' /><set value='15000' />
<set value='16000' /><set value='17600' /><set value='18800' /><set value='19700' />
<set value='21700' /><set value='21900' /><set value='22900' /><set value='20800' />
</dataset></chart>"
    render :text => charts
  end

  def course_study_data

    charts = ""
    render :text => charts
  end

end

