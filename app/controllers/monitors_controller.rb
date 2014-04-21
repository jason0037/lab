# encoding: utf-8
require 'pp'
require 'rufus-scheduler'

class MonitorsController < ApplicationController
  # GET /lab_cats
  # GET /lab_cats.json
  layout "blank"#,:except => [:show]

  def camera

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
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010101"
    datas = BData.where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str = ''
    datas.each do |data|
      cats_str += "<category label='#{data.read_at[8..14]}'/>"
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
    point_id=params[:point_id]
    if (point_id.blank?)
      point_id='000001'
    end
    case point_id
      when "000001"
        mind_wave_meaning="注意力"
        meaning_color="00dd00"
      when "000002"
        mind_wave_meaning="放松度"
        meaning_color="000093"
    end
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010101"
    datas = BData.where("point_id='#{point_id}' and read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str = ''
    datas.each do |data|
      cats_str += "<category label='#{data.read_at[8..14]}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='实时脑波' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='FFFFFF' bgAlpha='100'  canvasBorderThickness='1'
canvasBorderColor='008040' canvasBgColor='FFFFFF' canvasBgAlpha='100' divLineColor='008040'
vDivLineColor='008040' divLineAlpha='100' baseFontColor='#{meaning_color}' caption='#{mind_wave_meaning}监测/实时趋势图'
dataStreamURL='' refreshInterval='900' PYAxisName='100%' SYAxisName=' '
SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1' setAdaptiveSYMin='1'
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
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010101"
    datas = BData.where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str = ''
    datas.each do |data|
      cats_str += "<category label='#{data.read_at[8..14]}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='实时网络' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='00dd00'
caption='网络监测/实时趋势图' dataStreamURL='' refreshInterval='900' PYAxisName='网速(比特/秒)'
 SYAxisName=' ' SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1' setAdaptiveSYMin='1'
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
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140101010001"
    end_time = "20150101010101"
    datas = BData.select("read_at,sum(value) as value").group("read_at").where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str = ''
    datas.each do |data|
      cats_str += "<category label='#{data.read_at[8..14]}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='实时体态' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='00dd00'
caption='体态监测/实时趋势图' dataStreamURL='' refreshInterval='900' PYAxisName='动作幅度()'
SYAxisName=' ' SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1' setAdaptiveSYMin='1'
showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate' slantLabels='1'
labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='000000' toolTipBorderColor='008040'
baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0' legendBgColor='000000'
legendBorderColor='008040' legendShadow='0'><styles><definition>
<style name='MyFontStyle' type='font' size='24' bold='0'/></definition>
<application><apply toObject='Caption' styles='MyFontStyle' /></application>
</styles>#{categorys}#{datasets}</chart>"
    render :text => charts
  end
end

