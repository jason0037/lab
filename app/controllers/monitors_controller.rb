# encoding: utf-8
require 'pp'
require 'rufus-scheduler'

class MonitorsController < ApplicationController
  # GET /lab_cats
  # GET /lab_cats.json
  layout "blank"#,:except => [:show]

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
    datas = BData.where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

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
    datasets = "<dataset seriesName='实时能耗' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000'
canvasBgAlpha='100' divLineColor='008040' vDivLineColor='008040' divLineAlpha='100'
baseFontColor='00dd00' caption='能耗监测/实时趋势图' dataStreamURL='' refreshInterval='900'
PYAxisName='用电量(千瓦时)' SYAxisName='温度(℃)' SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1'
 setAdaptiveSYMin='1'  showRealTimeValue='0' realTimeValuePadding='10' showLabel='1'
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
vDivLineColor='008040' divLineAlpha='100' baseFontColor='#{meaning_color}' caption='#{mind_wave_meaning}监测/实时趋势图'
dataStreamURL='' refreshInterval='900' PYAxisName='100%' SYAxisName='课堂成绩'
SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate'
slantLabels='1' labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='FFFFFF'
toolTipBorderColor='008040' baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0'
legendBgColor='FFFFFF' legendBorderColor='008040' legendShadow='0'><styles><definition>
<style name='MyFontStyle' type='font' size='20' bold='0'/></definition><application>
<apply toObject='Caption' styles='MyFontStyle' /></application></styles>#{categorys}#{datasets}</chart>"
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
    datas = BData.where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

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
    datasets = "<dataset seriesName='实时网络' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='00dd00'
caption='网络监测/实时趋势图' dataStreamURL='' refreshInterval='900' PYAxisName='网速(比特/秒)'
 SYAxisName='课堂成绩' SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
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

    if size=='small'
      select =" '' as read_at,sum(value) as value"
    else
      select =" read_at,sum(value) as value "
    end


    datas = BData.select("#{select}").group("read_at").where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str = ''

    datas.each do |data|
      cats_str += "<category label='#{data.read_at}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='实时体态' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='FFFFFF' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='FFFFFF' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='#28004D'
caption='体态监测/实时趋势图' dataStreamURL='' refreshInterval='900' PYAxisName='体态变化值'
SYAxisName='课堂成绩' SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
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

    charts = '<chart manageresize="1" origw="300" origh="300" bgcolor="FFFFFF" upperlimit="100" lowerlimit="0" basefontcolor="FFFFFF" majortmnumber="11" majortmcolor="FFFFFF" majortmheight="8" minortmnumber="5" minortmcolor="FFFFFF" minortmheight="3" tooltipbordercolor="FFFFFF" tooltipbgcolor="333333" gaugeouterradius="100" gaugestartangle="225" gaugeendangle="-45" placevaluesinside="1" gaugeinnerradius="80%" annrenderdelay="0" gaugefillmix="" pivotradius="10" showpivotborder="0" pivotfillmix="{CCCCCC},{333333}" pivotfillratio="50,50" showshadow="0" gaugeoriginx="150" gaugeoriginy="150" >
<colorrange>
<color minvalue="0" maxvalue="50" code="C1E1C1" alpha="40" />
<color minvalue="50" maxvalue="85" code="F6F164" alpha="40" />
<color minvalue="85" maxvalue="120" code="F70118" alpha="40" />
</colorrange>
<dials>
<dial value="65" bordercolor="FFFFFF" bgcolor="000000,CCCCCC,000000" borderalpha="0" basewidth="10" />
</dials>
<annotations>
<annotationgroup x="150" y="150" showbelow="1">
<annotation type="circle" x="0" y="0" radius="145" fillcolor="CCCCCC,111111" fillpattern="linear" fillalpha="100,100" fillratio="50,50" fillangle="-45" />
<annotation type="circle" x="0" y="0" radius="120" fillcolor="111111,cccccc" fillpattern="linear" fillalpha="100,100" fillratio="50,50" fillangle="-45" />
<annotation type="circle" x="0" y="0" radius="110" color="666666" />
</annotationgroup>
</annotations>
</chart>'
    render :text => charts
  end

  def comprehensive_data

    charts = '<chart caption="综合分析" canvasborderalpha="0" radarborderalpha="50" radarborderthickness="1" radarfillcolor="FFFFFF" showlabels="1" drawanchors="0" ymaxvalue="10" showlimits="0" bgcolor="FFFFFF" legendborderalpha="0" >
<categories>
<category label="行为体态指数" />
<category label="注意力脑波指数" />
<category label="网速" />
<category label="课堂测试成绩" />
<category label="" />
<category label="" />
<category label="放松度脑波指数" />
</categories>
<dataset seriesname=" " color="008ee4" alpha="40">
<set value="8" />
<set value="9" />
<set value="9" />
<set value="8" />
<set value="7" />
<set value="9" />
<set value="8" />
</dataset>
<dataset seriesname=" " color="6baa01" alpha="40">
<set value="7" />
<set value="6" />
<set value="6" />
<set value="4" />
<set value="7" />
<set value="6" />
<set value="5" />
</dataset>
</chart>'
    render :text => charts
  end
end

